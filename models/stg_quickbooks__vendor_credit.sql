--To disable this model, set the using_vendor_credit variable within your dbt_project.yml file to False.
{{ config(enabled=var('using_vendor_credit', True)) }}

with base as (

    select * 
    from {{ ref('stg_quickbooks__vendor_credit_tmp') }}

),

fields as (

    select
        /*
        The below macro is used to generate the correct SQL for package staging models. It takes a list of columns 
        that are expected/needed (staging_columns from dbt_quickbooks_source/models/tmp/) and compares it with columns 
        in the source (source_columns from dbt_quickbooks_source/macros/).
        For more information refer to our dbt_fivetran_utils documentation (https://github.com/fivetran/dbt_fivetran_utils.git).
        */

        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_quickbooks__vendor_credit_tmp')),
                staging_columns=get_vendor_credit_columns()
            )
        }}

        {{ 
            fivetran_utils.source_relation(
                union_schema_variable='quickbooks_union_schemas', 
                union_database_variable='quickbooks_union_databases'
                ) 
        }}
        
    from base
),

final as (
    
    select 
        cast(id as {{ dbt.type_string() }}) as vendor_credit_id,
        balance,
        cast(doc_number as {{ dbt.type_string() }}) as doc_number,
        total_amount,
        currency_id,
        exchange_rate,
        created_at,
        cast(payable_account_id as {{ dbt.type_string() }}) as payable_account_id,
        cast(department_id as {{ dbt.type_string() }}) as department_id,
        private_note,
        transaction_date,
        cast(vendor_id as {{ dbt.type_string() }}) as vendor_id,
        _fivetran_deleted,
        source_relation
    from fields
)

select * 
from final
where not coalesce(_fivetran_deleted, false)
