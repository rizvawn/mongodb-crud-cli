#!/bin/bash
# Kör hela CRUD-övningen i sekvens och sparar utdata till crud_report.txt.
# Kör med: bash run_all.sh
# Kräver: mongosh och att MongoDB körs i Docker-containern 'mongodb'

REPORT="crud_report.txt"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

SCRIPTS=(
    "01_create_seed_orders.sh|CREATE: Seed 15 orders into the collection"
    "02_read_orders.sh|READ: Query by customer, amount, sort and limit"
    "03_update_orders.sh|UPDATE: Set status, push items, increment totalAmount"
    "04_delete_orders.sh|DELETE: Remove one cancelled and four low-value orders"
    "05_verify_collection.sh|VERIFY: Confirm final collection state"
)

{
    printf '=%.0s' {1..70}
    echo ""
    echo "      MongoDB CRUD Exercise - devops25_nosql.orders"
    echo "      Run: $TIMESTAMP"
    printf '=%.0s' {1..70}
    echo ""

    STEP=1
    for ENTRY in "${SCRIPTS[@]}"; do
        SCRIPT="${ENTRY%%|*}"
        LABEL="${ENTRY##*|}"

        echo ""
        echo "[ STEP $STEP of 5 ] $LABEL"
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
    echo "      Exercise complete."
    echo "      Full report saved to: $REPORT"
    printf '=%.0s' {1..70}
    echo ""

} | tee "$REPORT"