import pandas as pd
import holidays

def model(dbt, session):
    # 1. Configure the model and declare required open-source packages
    dbt.config(
        materialized="table",
        packages=["holidays", "pandas"]
    )

    # 2. Pull upstream data using dbt.ref() and convert to a Pandas DataFrame
    # Note: On Snowflake, dbt.ref() returns a Snowpark DataFrame by default.
    orders_df = dbt.ref("stg_orders").to_pandas()

    # 3. Instantiate the Brazilian holiday calendar
    br_holidays = holidays.Brazil()

    # 4. Create a helper function to check dates
    def is_holiday(date_col):
        if pd.isnull(date_col):
            return False
        return date_col.date() in br_holidays

    # 5. Apply the function to create a new boolean column
    # Critical step: Snowpark requires column names to be uppercase
    orders_df["IS_PURCHASED_ON_HOLIDAY"] = orders_df["ORDER_PURCHASE_TIMESTAMP"].apply(is_holiday)

    # 6. Return the final Pandas dataset directly
    return orders_df