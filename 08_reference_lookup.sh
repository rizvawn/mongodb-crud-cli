#!/bin/bash
# Demonstrerar referensbaserad uppslagning mellan orders och customers.
# Kör med: bash 08_reference_lookup.sh
# Kräver: mongosh och att MongoDB körs i Docker-containern 'mongodb'

(
    docker exec -i mongodb mongosh "mongodb://localhost:27017/devops25_nosql" --quiet <<'EOF'

    // --- Steg 1: Hämta den dyraste beställningen och läs ut customerId ---
    print("\n== Step 1: Find the most expensive order ==");
    const order = db.orders.find({}).sort({ totalAmount: -1 }).limit(1).toArray()[0];
    print("Looking up order with _id: " + order._id);
    printjson(order);

    // --- Steg 2: Använd customerId för att slå upp kunden
    print("\n== Step 2: Look up the customer using customerId from the order ==");
    const customer = db.customers.findOne(
        { customerId: order.customerId },
        { _id: 0 }
    );
    printjson(customer);

    // --- Steg 3: Kombinera och presentera resultatet ---
    print("\n== Step 3: Order and resolved customer in a combined result ==");
    printjson({
        orderId:        order._id,
        customer:       customer,
        totalAmount:    order.totalAmount,
        status:         order.status,
        createdAt:      order.createdAt
    });

EOF
) | sed 's/^devops25_nosql> //'