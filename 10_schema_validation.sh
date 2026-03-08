#!/bin/bash
# Lägger till schemavalidering på orders-kollektionen och testar ett ogiltigt dokument.
# Kör med: bash 10_schema_validation.sh
# Kräver: mongosh och att MongoDB körs i Docker-containern 'mongodb'

(
    docker exec -i mongodb mongosh "mongodb://localhost:27017/devops25_nosql" --quiet <<'EOF'

    // --- 1. Lägg till validator på orders ---
    print("\n== Step 1. Apply JSON Schema validator to orders collection ==");
    db.runCommand({
        collMod: "orders",
        validator: {
            $jsonSchema: {
                bsonType: "object",
                required: ["customerId", "createdAt", "Items", "totalAmount", "status"],
                properties: {
                    customerId: {
                        bsonType: "string",
                        description: "must be a string and is required"
                    },
                    createdAt: {
                        bsonType: "date",
                        description: "must be a date and is required"
                    },
                    items: {
                        bsonType: "array",
                        minItems: 1,
                        description: "must be a non-empty array and is required"
                    },
                    totalAmount: {
                        bsonType: "number",
                        minimum: 0,
                        description: "must be a non-negative number and is required"
                    },
                    status: {
                        bsonType: "string",
                        enum: ["pending", "processing", "shipped", "delivered", "cancelled"],
                        description: "must be one of the allowed status values"
                    }
                }
            }
        },
        validationLevel: "strict",
        validationAction: "error"
    });
    print("Validator applied successfully.");

    // --- 2. Försök infoga ett ogiltigt dokument ---
    print("\n== Step 2: Attempt to insert an invalid document ==");
    print("'createdAt' and 'items' are missing. 'totalAmount' is negative. 'status' is invalid.");

    try {
        db.orders.insertOne({
            customerId:     "visitor-999",
            totalAmount:    -50,
            status:         "unknown"
        });
        print("WARNING: Insert succeeded. Validator did not trigger.");
    } catch (e) {
        print("Insert correctly rejected by MongoDB.");
        print("Error code: " + e.code);
        print("Error message: " + e.errInfo.details.schemaRulesNotSatisfied
            .map(r => r.operatorName + ": " + (r.missingProperties || r.consideredValue || ""))
            .join(" | "));
    }

    // --- 3. Bekräfta att dokumnetantalet är ofärändrat ---
    print("\n== Step 3: Document count unchanged after failed insert ==");
    print("Total documents in orders: " + db.orders.countDocuments());
    
EOF
) | sed 's/^devops25_nosql> //'