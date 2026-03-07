#!/bin/bash
# Skapar kollektionen customers med fem kunder vars customerId matchar orders-kollektionen.
# Kör med: bash 06_create_customers.sh
# Kräver: mongosh och att MongoDB körs i Docker-containern 'mongodb'

(
    docker exec -i mongodb mongosh "mongodb://localhost:27017/devops25_nosql" --quiet <<'EOF'

    db.customers.drop();

    db.customers.insertMany([
        {
            customerId: "visitor-001",
            name: "Anna Lindström",
            email: "anna.lindstrom@example.se"
        },
         {
            customerId: "visitor-002",
            name: "Erik Bergman",
            email: "erik.bergman@example.se"
        },
         {
            customerId: "visitor-003",
            name: "Maria Johansson",
            email: "maria.johansson@example.se"
        },
         {
            customerId: "visitor-004",
            name: "Lars Eriksson",
            email: "lars.eriksson@example.se"
        },
         {
            customerId: "visitor-005",
            name: "Sara Nilsson",
            email: "sara.nilsson@example.se"
        },
    ]);

    print("Documents in customers collection: " + db.customers.countDocuments());
    print("\nAll customers:");
    db.customers.find({}, { _id: 0 }).forEach(printjson);
EOF
) | grep -v -x '^devops25_nosql>'