#!/bin/bash
# Kör hela CRUD-övningen i sekvens och sparar utdata till crud_report.txt.
# Kör med: bash run_all.sh
# Kräver: mongosh och att MongoDB körs i Docker-containern 'mongodb'

REPORT="mongodb_report.txt"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

SCRIPTS=(
    "01_create_orders.sh|CREATE: Seed 15 orders into the collection"
    "02_read_orders.sh|READ: Query by customer, amount, sort and limit"
    "03_update_orders.sh|UPDATE: Set status, push items, increment totalAmount"
    "04_delete_orders.sh|DELETE: Remove one cancelled and four low-value orders"
    "05_verify_collection.sh|VERIFY: Confirm final collection state"
    "06_create_customers.sh|CREATE: Seed 5 customers into the customers collection"
    "07_create_products.sh|CREATE: Seed 5 products into the products collection"
    "08_reference_lookup.sh|LOOKUP: Resolve customer from order via customerId"
    "09_embedded_vs_referenced.sh|MODEL: Compare embedded and referenced document patterns"
    "10_schema_validation.sh|VALIDATION: Apply JSON schema and test invalid insert"
    "11_crud_customers.sh|CRUD: Read, update and delete on the customers collection"
    "12_crud_products.sh|CRUD: Read, update and delete on the products collection"
)

{
    printf '=%.0s' {1..70}
    echo ""
    echo "              MongoDB Exercise"
    echo "              Run: $TIMESTAMP"
    printf '=%.0s' {1..70}
    echo ""

    STEP=1
    TOTAL=${#SCRIPTS[@]}
    for ENTRY in "${SCRIPTS[@]}"; do
        SCRIPT="${ENTRY%%|*}"
        LABEL="${ENTRY##*|}"

        echo ""
        echo "[ STEP $STEP of $TOTAL ] $LABEL"
        printf '=%.0s' {1..70}
        echo ""
        echo "      Script: $SCRIPT"
        printf '=%.0s' {1..70}
        echo ""

        if [[ ! -f "$SCRIPT" ]]; then
            echo "      ERROR: $SCRIPT not found. Aborting."
            exit 1
        fi

        bash "$SCRIPT"

        echo ""
        echo "      -- Step $STEP complete --"

        STEP=$((STEP + 1))
    done

    echo ""
    printf '=%.0s' {1..70}
    echo ""
    echo "          Exercise complete."
    echo "          Full report saved to: $REPORT"
    printf '=%.0s' {1..70}
    echo ""

} | tee "$REPORT"