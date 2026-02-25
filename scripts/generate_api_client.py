#!/usr/bin/env python3
"""Generate minimal Dart API SDK from an OpenAPI JSON document."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
from textwrap import dedent

TYPE_MAP = {
    "string": "String",
    "integer": "int",
    "number": "double",
    "boolean": "bool",
}


def dart_type(schema: dict) -> str:
    if "$ref" in schema:
        return schema["$ref"].split("/")[-1]
    if schema.get("type") == "array":
        return f"List<{dart_type(schema['items'])}>"
    return TYPE_MAP.get(schema.get("type", "string"), "String")


def render_model(name: str, schema: dict) -> str:
    props = schema.get("properties", {})
    required = set(schema.get("required", []))
    fields = []
    ctor_args = []
    from_json = []
    to_json = []

    for prop_name, prop_schema in props.items():
        dtype = dart_type(prop_schema)
        nullable = "" if prop_name in required else "?"
        fields.append(f"  final {dtype}{nullable} {prop_name};")
        ctor_args.append(f"    {'required ' if prop_name in required else ''}this.{prop_name},")

        if dtype.startswith("List<"):
            inner = dtype[5:-1]
            if inner in TYPE_MAP.values() or inner == "String":
                from_json.append(
                    f"      {prop_name}: (json['{prop_name}'] as List<dynamic>? ?? const []).map((e) => e as {inner}).toList(growable: false),"
                )
            else:
                from_json.append(
                    f"      {prop_name}: (json['{prop_name}'] as List<dynamic>? ?? const []).map((e) => {inner}.fromJson(e as Map<String, dynamic>)).toList(growable: false),"
                )
        elif dtype in TYPE_MAP.values() or dtype == "String":
            cast = "num" if dtype == "double" else dtype
            val = f"(json['{prop_name}'] as {cast}{'?' if prop_name not in required else ''})"
            if dtype == "double":
                val += "?.toDouble()" if prop_name not in required else ".toDouble()"
            from_json.append(f"      {prop_name}: {val},")
        else:
            from_json.append(
                f"      {prop_name}: json['{prop_name}'] == null ? null : {dtype}.fromJson(json['{prop_name}'] as Map<String, dynamic>),"
            )

        to_json.append(f"      '{prop_name}': {prop_name},")

    return dedent(
        f"""
        class {name} {{
        {chr(10).join(fields)}

          const {name}({{
        {chr(10).join(ctor_args)}
          }});

          factory {name}.fromJson(Map<String, dynamic> json) {{
            return {name}(
        {chr(10).join(from_json)}
            );
          }}

          Map<String, dynamic> toJson() {{
            return {{
        {chr(10).join(to_json)}
            }};
          }}
        }}
        """
    ).strip()


def render_list_response(name: str, item_type: str) -> str:
    return dedent(
        f"""
        class {name} {{
          final List<{item_type}> items;

          const {name}({{required this.items}});

          factory {name}.fromJson(Map<String, dynamic> json) {{
            return {name}(
              items: (json['items'] as List<dynamic>? ?? const [])
                  .map((e) => {item_type}.fromJson(e as Map<String, dynamic>))
                  .toList(growable: false),
            );
          }}
        }}
        """
    ).strip()


def render_service(spec: dict) -> str:
    server_url = spec.get("servers", [{"url": ""}])[0]["url"]
    methods = []
    for path, path_info in spec.get("paths", {}).items():
        op = path_info.get("get")
        if not op:
            continue
        op_id = op["operationId"]
        params = op.get("parameters", [])
        args = []
        query_lines = ["    final queryParams = <String, String>{};"]
        for p in params:
            name = p["name"]
            p_type = dart_type(p.get("schema", {"type": "string"}))
            args.append(f"{p_type}? {name}")
            query_lines.append(f"    if ({name} != null) queryParams['{name}'] = {name}.toString();")
        args_str = ", ".join(args)
        methods.append(
            dedent(
                f"""
                Uri {op_id}Uri({args_str}) {{
                {chr(10).join(query_lines)}
                  final base = Uri.parse(baseUrl);
                  final normalizedPath = ('${{base.path.endsWith('/') ? base.path.substring(0, base.path.length - 1) : base.path}}{path}').replaceAll('//', '/');
                  return base.replace(path: normalizedPath, queryParameters: queryParams.isEmpty ? null : queryParams);
                }}
                """
            ).strip()
        )

    return dedent(
        f"""
        class DiscoveryGeneratedApi {{
          final String baseUrl;

          const DiscoveryGeneratedApi({{this.baseUrl = '{server_url}'}});

        {chr(10).join(methods)}
        }}
        """
    ).strip()


def generate(spec_path: Path, out_dir: Path) -> str:
    spec = json.loads(spec_path.read_text(encoding="utf-8"))
    schemas = spec.get("components", {}).get("schemas", {})
    model_chunks = [
        "// GENERATED CODE - DO NOT MODIFY BY HAND.",
        "// Source: docs/openapi/discovery_api.openapi.json",
        "",
    ]

    for name, schema in schemas.items():
        if schema.get("type") == "object" and "items" not in schema.get("properties", {}):
            model_chunks.append(render_model(name, schema))
            model_chunks.append("")

    for name, schema in schemas.items():
        props = schema.get("properties", {})
        if "items" in props and "$ref" in props["items"].get("items", {}):
            model_chunks.append(render_list_response(name, props["items"]["items"]["$ref"].split("/")[-1]))
            model_chunks.append("")

    service_chunks = [
        "// GENERATED CODE - DO NOT MODIFY BY HAND.",
        "// Source: docs/openapi/discovery_api.openapi.json",
        "",
        render_service(spec),
        "",
    ]

    out_dir.mkdir(parents=True, exist_ok=True)
    (out_dir / "models.dart").write_text("\n".join(model_chunks), encoding="utf-8")
    (out_dir / "discovery_generated_api.dart").write_text("\n".join(service_chunks), encoding="utf-8")

    digest = hashlib.sha256(spec_path.read_bytes()).hexdigest()
    (out_dir / "source_spec.sha256").write_text(f"{digest}\n", encoding="utf-8")
    return digest


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--spec", required=True)
    parser.add_argument("--out", required=True)
    args = parser.parse_args()
    generate(Path(args.spec), Path(args.out))


if __name__ == "__main__":
    main()
