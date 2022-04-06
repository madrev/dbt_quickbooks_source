--To enable this model, set the using_invoice variable within your dbt_project.yml file to True.
{{ config(enabled=var('using_invoice', True)) }}

{{
    fivetran_utils.union_data(
        table_identifier='invoice',
        database_variable='quickbooks_database',
        schema_variable='quickbooks_schema',
        default_database=target.database,
        default_schema='quickbooks',
        default_variable='invoice'
    )
}}