# MongoDB: Från grunden via Linux CLI

Detta projekt är en övning med MongoDB där fokus ligger på de mest grundläggande
koncepten.

### Varför Bash och CLI?
Efter att nyligen ha arbetat på Linux och terminalmiljön föll det sig
naturligt att genomföra denna övning helt och hållet via kommandoraden. Istället för
att använda MongoDB Atlas + Compass har jag valt att strukturera hela processen i en serie Bash-skript.

Detta tillvägagångssätt ger flera fördelar:

- **Automatisering**: Varje steg i processen är repeterbart och dokumenterat i kod.
- **Renhet**: Genom att använda MongoDB Shell (`mongosh`) direkt ser man exakt hur databasen svarar utan abstraktionslager.
- **Miljöhantering**: Genom att köra MongoDB i Docker säkerställs en isolerad och ren utvecklingsmiljö som är lätt att sätta upp och ta bort.

### Projektets struktur
Övningen använder databasen `devops25_nosql` med kollektionen `orders`. Arbetet är uppdelat i fem numrerade Bash-skript som körs stegvis, ett per fas av CRUD-cykeln: skapa, läsa, uppdatera och radera dokument.

Innan skripten körs startas MongoDB med ett enkelt Docker-kommando:
`docker run -d --name mongodb -p 27017:27017 mongo:latest`
Därefter är `mongosh` tillgängligt mot `localhost:27017`.

### Steg 1: Skapa dokument (Create)
Skriptet `01_create_seed_orders.sh` skapar kollektionen `orders` i databasen `devops25_nosql` och fyller den med femton orderdokument från en fiktiv svensk souvenirbutik. Fem kunder används genomgående i datan, identifierade som `visitor-001` till `visitor-005`. Produktsortimentet består av arton distinkta souvenirer, från dalahästar och vikingahjälmar till samiska armband och lapplandshalsdukar. Fältet `totalAmount` är förutsummat utifrån kvantitet och pris per produkt. Statusalternativen som förekommer är `delivered`, `shipped`, `pending` och `cancelled`. Anslutningen till MongoDB sker via `docker exec` mot en körande container.