--To disable this model, set the using_invoice_bundle variable within your dbt_project.yml file to False.
{{ config(enabled=var('using_invoice_bundle', True)) }}

{{
    fivetran_utils.union_data(
        table_identifier='bundle_item',
        database_variable='quickbooks_database',
        schema_variable='quickbooks_schema',
        default_database=target.database,
        default_schema='quickbooks',
        default_variable='bundle_item'
    )
}}