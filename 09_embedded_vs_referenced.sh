#!/bin/bash
# Jämför inbäddad och referensbaserad dokumentmodellering i orders-kollektionen.
# Kör med: bash 09_embedded_vs_referenced.sh
# Kräver: mongosh och att MongoDB körs i Docker-containern 'mongodb'

(
    docker exec -i mongodb mongosh "mongodb://localhost:27017/devops25_nosql" --quiet <<'EOF'

    // --- 1. Exempel på referensbaserad order (befintligt mönster) ---
    print("\n== Referenced model: existing order (customer referenced by ID) ==");
    db.orders.findOne(
        { customerId: "visitor-001", totalAmount: 1050 },
        { customerId: 1, items: 1, totalAmount: 1, status: 1, _id: 0 }
    );

    // --- 2. Infoga ett testdokument med inbäddad kunddata ---
    print("\n== Inserting test order with embedded customer data ==");
    db.orders.insertOne({
        customer: {
            customerId: "visitor-002",
            name:       "Erik Bergman",
            email:      "erik.bergman@example.se"
    },
    createdAt:          new Date("2025-05-01"),
    items: [
        { productId: "souvenir-04", name: "Dala Horse Figurine", quantity: 2, price: 200 }
    ],
    totalAmount:    400,
    status:         "pending"
    });

    // --- 3. Visa det inbäddade dokumentet ---
    print("\n== Embedded model: test order with full customer object inside ==");
    db.orders.findOne(
        { "customer.customerId": "visitor-002", totalAmount: 400 },
        { customer: 1, items: 1, totalAmount: 1, status: 1, _id: 0 }
    );

    // --- 4. Infoga ett testdokument med referensbaserad produkt ---
    print("\n== Inserting test order with referenced product (productId only in items) ==");
    db.orders.insertOne({
        customerId: "visitor-004",
        createdAt:  new Date("2025-05-02"),
        items: [
            { productId: "souvenir-01" }
        ],
        totalAmount: 120,
        status:      "pending"
    });

    // --- 5. Visa det referensbaserade produktdokument och slå upp produkten ---
    print("\n== Referenced product model: order item contains only productId ==");
    const refOrder = db.orders.findOne({ "items.productId": "souvenir-01", totalAmount: 120 });
    printjson({ orderId: refOrder._id, items: refOrder.items });

    print("\n== Product resolved from products collection ==");
    db.products.findOne(
        { productId: refOrder.items[0].productId },
        { _id: 0 }
    );

    print("\n== Total documents in orders after test inserts: " + db.orders.countDocuments());
    
EOF
) | sed 's/^devops25_nosql> //'