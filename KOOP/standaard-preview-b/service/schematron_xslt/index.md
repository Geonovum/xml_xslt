# XSLT2 vertalingen van schematrons

De implementatie van STOP maakt gebruik van schema's en schematrons, die in [/schema](https://koop.gitlab.io/STOP/voorinzage/standaard-preview-b/go/go.html?id=git%3Aschema) uitgeleverd worden. Een schematron is een standaard manier om in het XML-domein bedrijfsregels vast te leggen. Uitgebreidere XML-georiënteerde software kan een schematron direct uitvoeren.

Als dat niet het geval is, dan kan een schematron worden omgezet in een [XSLT versie 2.0](https://www.w3.org/TR/xslt20/)-transformatie volgens een [standaard procedé](https://github.com/Schematron/schematron). Het resultaat is in deze map te vinden, inclusief [catalog](https://koop.gitlab.io/STOP/voorinzage/standaard-preview-b/go/go.html?id=doc%3Aschemata_gebruik%23catalog) die de URL van de schematrons koppelt aan de XSLT-bestanden.

De XSLT2 vertalingen zijn getest met [Saxon Home Edition](https://www.saxonica.com/download/download_page.xml) (aldaar vermeld als de Saxon HE editie), een [open source](https://www.saxonica.com/support/opensource.xml) XSLT/XQuery-implementatie.
