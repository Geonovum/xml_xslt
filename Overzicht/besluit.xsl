<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dso="https://www.dso.nl/" xmlns:my="http://mijn.eigen.ns" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0" xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:k="http://www.geostandaarden.nl/imow/kaart" xmlns:l="http://www.geostandaarden.nl/imow/locatie" xmlns:r="http://www.geostandaarden.nl/imow/regels" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="#all">
  <xsl:output method="xhtml" encoding="UTF-8" indent="no" omit-xml-declaration="yes" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
  <xsl:strip-space elements="*"/>

  <xsl:param name="opdracht.dir" select="'C:/Werkbestanden/Geonovum/Overzicht/opdracht'"/>
  <xsl:param name="besluit" select="collection(concat('file:/',$opdracht.dir,'?select=*.xml;recurse=yes'))/AanleveringBesluit" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"/>
  <xsl:param name="aanleveringen" select="collection(concat('file:/',$opdracht.dir,'?select=*.xml;recurse=yes'))//Aanlevering" xpath-default-namespace="http://www.geostandaarden.nl/bestanden-ow/manifest-ow"/>
  <xsl:param name="omgevingsnormaanduidingen" select="collection(concat('file:/',$opdracht.dir,'?select=*.xml;recurse=yes'))//rol:Omgevingsnorm"/>
  <xsl:param name="omgevingswaardeaanduidingen" select="collection(concat('file:/',$opdracht.dir,'?select=*.xml;recurse=yes'))//rol:Omgevingswaarde"/>
  <xsl:param name="hoofdlijnaanduidingen" select="collection(concat('file:/',$opdracht.dir,'?select=*.xml;recurse=yes'))//vt:Hoofdlijn"/>
  <xsl:param name="kaarten" select="collection(concat('file:/',$opdracht.dir,'?select=*.xml;recurse=yes'))//k:Kaart"/>
  <xsl:param name="gml">
    <xsl:for-each select="collection(concat('file:/',$opdracht.dir,'?select=*.gml;recurse=yes'))">
      <xsl:variable name="bestand"><xsl:value-of select="fn:tokenize(fn:document-uri(.),'/')[last()]"/></xsl:variable>
      <xsl:variable name="gio" select="./descendant::geo:GeoInformatieObjectVersie"/>
      <xsl:choose>
        <xsl:when test="$gio//geo:Locatie/geo:kwantitatieveNormwaarde">
          <xsl:for-each-group select="$gio//geo:Locatie" group-by="(geo:kwantitatieveNormwaarde,geo:kwantitatieveNormwaarde)">
            <xsl:element name="gio">
              <xsl:element name="Waarde">
                <xsl:element name="norm"><xsl:value-of select="$gio/geo:normlabel"/></xsl:element>
                <xsl:element name="waarde"><xsl:value-of select="current-grouping-key()"/></xsl:element>
                <xsl:element name="eenheid"><xsl:value-of select="$gio/geo:eenheidlabel"/></xsl:element>
              </xsl:element>
              <xsl:for-each select="current-group()">
                <xsl:variable name="locatie" select="."/>
                <xsl:element name="Locatie">
                  <xsl:if test="$locatie/geo:naam">
                    <xsl:element name="naam"><xsl:value-of select="$locatie/geo:naam"/></xsl:element>
                  </xsl:if>
                  <xsl:element name="geo-id"><xsl:value-of select="$locatie//basisgeo:id"/></xsl:element>
                  <xsl:element name="join-id"><xsl:value-of select="$gio/geo:FRBRExpression"/></xsl:element>
                  <xsl:element name="bestand"><xsl:value-of select="$bestand"/></xsl:element>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
          </xsl:for-each-group>
        </xsl:when>
        <xsl:otherwise>
          <xsl:element name="gio">
            <xsl:for-each select="$gio//geo:Locatie">
              <xsl:variable name="locatie" select="."/>
              <xsl:element name="Locatie">
                <xsl:if test="$locatie/geo:naam">
                  <xsl:element name="naam"><xsl:value-of select="$locatie/geo:naam"/></xsl:element>
                </xsl:if>
                <xsl:element name="geo-id"><xsl:value-of select="$locatie//basisgeo:id"/></xsl:element>
                <xsl:element name="join-id"><xsl:value-of select="$gio/geo:FRBRExpression"/></xsl:element>
                <xsl:element name="bestand"><xsl:value-of select="$bestand"/></xsl:element>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:param>

  <xsl:param name="waardelijsten" select="document('waardelijsten OP 1.3.0.xml')//Waardelijst"/>

  <!-- factor wordt gebruikt bij de berekening van de breedt van figuren -->
  <xsl:param name="factor" select="fn:max($besluit//Figuur/fn:sum(Illustratie/number(@breedte))) div 100" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>

  <xsl:template match="/">
    <html>
      <head>
        <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
        <link rel="stylesheet" type="text/css" href="besluit.css"/>
        <title>
          <xsl:apply-templates select="$besluit//BesluitMetadata/officieleTitel/node()" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
        </title>
      </head>
      <body>
        <script type="text/javascript">function ShowHide(obj){var tbody = obj.parentNode.getElementsByTagName("tbody")[0];var old = tbody.style.display;tbody.style.display = (old == "none"?"":"none");}</script>
        <div class="content">
          <div class="uitleg">
            <p class="standaard">Het aangeleverde besluit bestaat uit een besluitdeel en één of meer regelingdelen. Door op onderstaande tekst te klikken wordt de informatie zichtbaar.</p>
          </div>
          <xsl:for-each select="$besluit/BesluitVersie" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/">
            <xsl:variable name="FRBRWork" select="ExpressionIdentificatie/FRBRWork/text()" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
            <xsl:variable name="FRBRExpression" select="ExpressionIdentificatie/FRBRExpression/text()" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
            <table class="deel">
              <thead onclick="ShowHide(this)">
                <tr class="deel">
                  <th>
                    <p class="deel">Besluit</p>
                    <p class="standaard">
                      <xsl:value-of select="$FRBRExpression"/>
                    </p>
                  </th>
                </tr>
              </thead>
              <tbody style="display: none">
                <tr>
                  <td>
                    <xsl:apply-templates select="$besluit//(BesluitCompact|BesluitKlassiek)" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
                  </td>
                </tr>
              </tbody>
            </table>
          </xsl:for-each>
          <xsl:for-each select="$besluit/RegelingVersieInformatie" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/">
            <xsl:variable name="FRBRWork" select="ExpressionIdentificatie/FRBRWork/text()" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
            <xsl:variable name="FRBRExpression" select="ExpressionIdentificatie/FRBRExpression/text()" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
            <table class="deel">
              <thead onclick="ShowHide(this)">
                <tr>
                  <th>
                    <p class="deel">Regeling</p>
                    <p class="standaard">
                      <xsl:value-of select="$FRBRExpression"/>
                    </p>
                  </th>
                </tr>
              </thead>
              <tbody style="display: none">
                <tr>
                  <td>
                    <xsl:apply-templates select="$besluit//(BesluitCompact|BesluitKlassiek)//(RegelingCompact|RegelingKlassiek|RegelingTijdelijkdeel|RegelingVrijetekst|RegelingMutatie)[./@wordt=$FRBRExpression]" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
                      <xsl:with-param name="check">
                        <xsl:for-each select="$aanleveringen[./WorkIDRegeling=$FRBRWork]/Bestand/naam/text()" xpath-default-namespace="http://www.geostandaarden.nl/bestanden-ow/manifest-ow">
                          <xsl:copy-of select="document(concat('file:/',$opdracht.dir,'/',.))//((r:Regeltekst,r:Instructieregel,r:Omgevingswaarderegel,r:RegelVoorIedereen,l:Ambtsgebied,l:Gebiedengroep,l:Gebied,l:Lijnengroep,l:Lijn,l:Puntengroep,l:Punt,rol:Activiteit,ga:Gebiedsaanwijzing,rol:Omgevingsnorm,rol:Omgevingswaarde,vt:Divisie,vt:Divisietekst,vt:Tekstdeel,vt:Hoofdlijn,k:Kaart))"/>
                        </xsl:for-each>
                      </xsl:with-param>
                    </xsl:apply-templates>
                  </td>
                </tr>
              </tbody>
            </table>
          </xsl:for-each>
        </div>
      </body>
    </html>
  </xsl:template>

  <!-- algemeen -->

  <xsl:template match="element()">
    <xsl:param name="check" select="null"/>
    <xsl:apply-templates select="./node()">
      <xsl:with-param name="check" select="$check"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:copy-of select="."/>
  </xsl:template>

  <!-- container -->

  <xsl:template match="WijzigBijlage" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <!-- doe niets -->
  </xsl:template>

  <xsl:template match="Afdeling|Artikel|Boek|Deel|Hoofdstuk|Paragraaf|Subparagraaf|Subsubparagraaf|Titel|WijzigArtikel" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:param name="check" select="null"/>
    <xsl:variable name="wId" select="./@wId"/>
    <xsl:variable name="regeltekst" select="$check/r:Regeltekst[@wId=$wId]"/>
    <xsl:variable name="regel" select="$check/(r:Instructieregel|r:Omgevingswaarderegel|r:RegelVoorIedereen)[r:artikelOfLid/r:RegeltekstRef/@xlink:href=$regeltekst/r:identificatie]"/>
    <xsl:if test="$regel">
      <div class="show_object">
        <div class="object">
          <xsl:call-template name="object">
            <xsl:with-param name="check" select="$check"/>
            <xsl:with-param name="current" select="$regel"/>
          </xsl:call-template>
        </div>
      </div>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="fn:string-join(Kop/element(),'') ne ''">
        <section class="{lower-case(name())}">
          <xsl:apply-templates select="./node()">
            <xsl:with-param name="check" select="$check"/>
          </xsl:apply-templates>
        </section>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="./node()">
          <xsl:with-param name="check" select="$check"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="AlgemeneToelichting|ArtikelgewijzeToelichting|Bijlage|Divisie|Divisietekst|InleidendeTekst|Toelichting" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:param name="check" select="null"/>
    <xsl:variable name="wId" select="./@wId"/>
    <xsl:variable name="divisie" select="$check/(vt:Divisie|vt:Divisietekst)[@wId=$wId]"/>
    <xsl:variable name="tekstdeel" select="$check/vt:Tekstdeel[vt:divisieaanduiding/(vt:DivisieRef|vt:DivisietekstRef)/@xlink:href=$divisie/vt:identificatie]"/>
    <xsl:if test="$tekstdeel">
      <div class="show_object">
        <div class="object">
          <xsl:call-template name="object">
            <xsl:with-param name="check" select="$check"/>
            <xsl:with-param name="current" select="$tekstdeel"/>
          </xsl:call-template>
        </div>
      </div>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="fn:string-join(Kop/element(),'') ne ''">
        <section class="divisie">
          <xsl:apply-templates select="./node()"/>
        </section>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="./node()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="Lid" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:param name="check" select="null"/>
    <xsl:variable name="wId" select="./@wId"/>
    <xsl:variable name="regeltekst" select="$check/r:Regeltekst[@wId=$wId]"/>
    <xsl:variable name="regel" select="$check/(r:Instructieregel|r:Omgevingswaarderegel|r:RegelVoorIedereen)[r:artikelOfLid/r:RegeltekstRef/@xlink:href=$regeltekst/r:identificatie]"/>
    <xsl:if test="$regel">
      <div class="show_object">
        <div class="object">
          <xsl:call-template name="object">
            <xsl:with-param name="check" select="$check"/>
            <xsl:with-param name="current" select="$regel"/>
          </xsl:call-template>
        </div>
      </div>
    </xsl:if>
    <section class="lid">
      <div class="lidnummer">
        <xsl:apply-templates select="./LidNummer"/>
      </div>
      <xsl:apply-templates select="./Inhoud"/>
    </section>
  </xsl:template>

  <!-- object -->

  <xsl:template name="waarde">
    <xsl:param name="current"/>
    <xsl:choose>
      <xsl:when test="$current/self::element()|$current/self::attribute()|$current/element()">
        <xsl:attribute name="style" select="string('padding: 0pt;')"/>
        <table class="object">
          <colgroup>
            <col width="140px"/>
            <col width="auto"/>
          </colgroup>
          <tbody>
            <xsl:for-each select="$current/descendant-or-self::element()[text()|attribute()]|$current/self::attribute()">
              <tr>
                <td colspan="1" rowspan="1">
                  <p class="naam"><xsl:value-of select="./name()"/></p>
                </td>
                <td colspan="1" rowspan="1">
                  <xsl:choose>
                    <xsl:when test="self::element()">
                      <xsl:call-template name="waarde">
                        <xsl:with-param name="current" select="text(),element(),attribute()"/>
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="self::attribute()">
                      <p class="waarde"><xsl:value-of select="."/></p>
                    </xsl:when>
                  </xsl:choose>
                </td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
      </xsl:when>
      <xsl:when test="$current/self::text()">
        <xsl:variable name="waarde" select="."/>
        <xsl:variable name="label" select="$waardelijsten//Waarde[./id=$waarde]/label"/>
        <xsl:choose>
          <xsl:when test="$label">
            <p class="waarde"><xsl:value-of select="concat($waarde,' ')"/><span class="label"><xsl:value-of select="concat('(',fn:string-join(fn:distinct-values($label),', '),')')"/></span></p>
          </xsl:when>
          <xsl:otherwise>
            <p class="waarde"><xsl:value-of select="$waarde"/></p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="error">
    <xsl:param name="message"/>
    <table class="error">
      <colgroup>
        <col width="140px"/>
        <col width="auto"/>
      </colgroup>
      <tbody>
        <tr>
          <td colspan="1" rowspan="1">
            <p class="naam"><xsl:value-of select="string('error')"/></p>
          </td>
          <td colspan="1" rowspan="1">
            <p class="waarde"><xsl:value-of select="$message"/></p>
          </td>
        </tr>
      </tbody>
    </table>
  </xsl:template>

  <xsl:template name="object">
    <xsl:param name="check" select="null"/>
    <xsl:param name="current"/>
    <xsl:for-each select="$current/self::element()">
      <table class="object">
        <colgroup>
          <col width="140px"/>
          <col width="auto"/>
        </colgroup>
        <thead onclick="ShowHide(this)">
          <tr>
            <th colspan="2" rowspan="1"><p class="object"><xsl:value-of select="./local-name()"/></p></th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="(./element()|attribute())">
            <tr>
              <td colspan="1" rowspan="1"><p class="naam"><xsl:value-of select="./local-name()"/></p></td>
              <td colspan="1" rowspan="1">
                <xsl:choose>
                  <xsl:when test="./self::r:artikelOfLid|./self::vt:divisieaanduiding|./self::k:gebiedsaanwijzingweergave">
                    <xsl:for-each select="./element()/@xlink:href">
                      <p class="waarde"><xsl:value-of select="."/></p>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:when test="./self::l:geometrie">
                    <xsl:attribute name="style" select="string('padding: 0pt;')"/>
                    <xsl:variable name="id" select="./l:GeometrieRef/@xlink:href"/>
                    <xsl:choose>
                      <xsl:when test="$gml/gio/Locatie[geo-id=$id]">
                        <xsl:call-template name="object">
                          <xsl:with-param name="check" select="$check"/>
                          <xsl:with-param name="current" select="$gml/gio/Locatie[geo-id=$id]"/>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:call-template name="error">
                          <xsl:with-param name="message" select="concat($id,' verwijst niet naar een object')"/>
                        </xsl:call-template>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="./self::r:locatieaanduiding|./self::rol:locatieaanduiding|./self::ga:locatieaanduiding|./self::vt:locatieaanduiding">
                    <xsl:attribute name="style" select="string('padding: 0pt;')"/>
                    <xsl:for-each select="./(l:AmbtsgebiedRef|l:LocatieRef)/@xlink:href">
                      <xsl:variable name="id" select="."/>
                      <xsl:choose>
                        <xsl:when test="$check/(l:Ambtsgebied|l:Gebiedengroep|l:Gebied|l:Lijnengroep|l:Lijn|l:Puntengroep|l:Punt)[l:identificatie=$id]">
                          <xsl:call-template name="object">
                            <xsl:with-param name="check" select="$check"/>
                            <xsl:with-param name="current" select="$check/(l:Ambtsgebied|l:Gebiedengroep|l:Gebied|l:Lijnengroep|l:Lijn|l:Puntengroep|l:Punt)[l:identificatie=$id]"/>
                          </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:call-template name="error">
                            <xsl:with-param name="message" select="concat($id,' verwijst niet naar een object')"/>
                          </xsl:call-template>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:when test="./self::l:groepselement">
                    <xsl:attribute name="style" select="string('padding: 0pt;')"/>
                    <xsl:variable name="id" select="./l:GebiedRef/@xlink:href"/>
                    <xsl:choose>
                      <xsl:when test="$check/(l:Ambtsgebied|l:Gebiedengroep|l:Gebied|l:Lijnengroep|l:Lijn|l:Puntengroep|l:Punt)[l:identificatie=$id]">
                        <xsl:call-template name="object">
                          <xsl:with-param name="check" select="$check"/>
                          <xsl:with-param name="current" select="$check/(l:Ambtsgebied|l:Gebiedengroep|l:Gebied|l:Lijnengroep|l:Lijn|l:Puntengroep|l:Punt)[l:identificatie=$id]"/>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:call-template name="error">
                          <xsl:with-param name="message" select="concat($id,' verwijst niet naar een object')"/>
                        </xsl:call-template>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="./self::r:activiteitaanduiding">
                    <xsl:attribute name="style" select="string('padding: 0pt;')"/>
                    <xsl:variable name="id" select="./rol:ActiviteitRef/@xlink:href"/>
                    <xsl:choose>
                      <xsl:when test="$check/rol:Activiteit[rol:identificatie=$id]">
                        <xsl:call-template name="object">
                          <xsl:with-param name="check" select="$check"/>
                          <xsl:with-param name="current" select="$check/rol:Activiteit[rol:identificatie=$id]"/>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:call-template name="error">
                          <xsl:with-param name="message" select="concat($id,' verwijst niet naar een object')"/>
                        </xsl:call-template>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:call-template name="object">
                      <xsl:with-param name="check" select="$check"/>
                      <xsl:with-param name="current" select="./r:ActiviteitLocatieaanduiding"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="./self::rol:gerelateerdeActiviteit|./self::rol:bovenliggendeActiviteit">
                    <xsl:attribute name="style" select="string('padding: 0pt;')"/>
                    <xsl:variable name="activiteit-id" select="./rol:ActiviteitRef/@xlink:href"/>
                    <xsl:for-each select="$activiteit-id">
                      <xsl:variable name="id" select="string(.)"/>
                      <xsl:choose>
                        <xsl:when test="$check/rol:Activiteit[rol:identificatie=$id]">
                          <xsl:call-template name="object">
                            <xsl:with-param name="check" select="$check"/>
                            <xsl:with-param name="current" select="$check/rol:Activiteit[rol:identificatie=$id]"/>
                          </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                          <p class="waarde"><xsl:value-of select="$id"/></p>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:when test="./self::r:gebiedsaanwijzing|./self::vt:gebiedsaanwijzing">
                    <xsl:attribute name="style" select="string('padding: 0pt;')"/>
                    <xsl:variable name="id" select="./ga:GebiedsaanwijzingRef/@xlink:href"/>
                    <xsl:choose>
                      <xsl:when test="$check/ga:Gebiedsaanwijzing[ga:identificatie=$id]">
                        <xsl:call-template name="object">
                          <xsl:with-param name="check" select="$check"/>
                          <xsl:with-param name="current" select="$check/ga:Gebiedsaanwijzing[ga:identificatie=$id]"/>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:call-template name="error">
                          <xsl:with-param name="message" select="concat($id,' verwijst niet naar een object')"/>
                        </xsl:call-template>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="./self::r:omgevingsnormaanduiding">
                    <xsl:attribute name="style" select="string('padding: 0pt;')"/>
                    <xsl:variable name="id" select="./rol:OmgevingsnormRef/@xlink:href"/>
                    <xsl:choose>
                      <xsl:when test="$omgevingsnormaanduidingen[rol:identificatie=$id]">
                        <xsl:call-template name="object">
                          <xsl:with-param name="check" select="$check"/>
                          <xsl:with-param name="current" select="$omgevingsnormaanduidingen[rol:identificatie=$id]"/>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:call-template name="error">
                          <xsl:with-param name="message" select="concat(fn:string-join($id,', '),' verwijst niet naar een object')"/>
                        </xsl:call-template>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="./self::r:omgevingswaardeaanduiding">
                    <xsl:attribute name="style" select="string('padding: 0pt;')"/>
                    <xsl:variable name="id" select="./rol:OmgevingswaardeRef/@xlink:href"/>
                    <xsl:choose>
                      <xsl:when test="$omgevingswaardeaanduidingen[rol:identificatie=$id]">
                        <xsl:call-template name="object">
                          <xsl:with-param name="check" select="$check"/>
                          <xsl:with-param name="current" select="$omgevingswaardeaanduidingen[rol:identificatie=$id]"/>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:call-template name="error">
                          <xsl:with-param name="message" select="concat($id,' verwijst niet naar een object')"/>
                        </xsl:call-template>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="./self::rol:normwaarde">
                    <xsl:attribute name="style" select="string('padding: 0pt;')"/>
                    <xsl:call-template name="object">
                      <xsl:with-param name="check" select="$check"/>
                      <xsl:with-param name="current" select="./rol:Normwaarde"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="./self::rol:kwantitatieveWaarde">
                    <xsl:attribute name="style" select="string('padding: 0pt;')"/>
                    <xsl:variable name="locatie-id" select="$current//l:LocatieRef/@xlink:href"/>
                    <xsl:variable name="gebied-id" select="$check/(l:Ambtsgebied|l:Gebiedengroep|l:Gebied|l:Lijnengroep|l:Lijn|l:Puntengroep|l:Punt)[l:identificatie=$locatie-id]//l:GeometrieRef/@xlink:href"/>
                    <xsl:variable name="waarde" select="$gml/gio[Locatie/geo-id=$gebied-id]/Waarde"/>
                    <xsl:choose>
                      <xsl:when test="$waarde">
                        <xsl:call-template name="object">
                          <xsl:with-param name="check" select="$check"/>
                          <xsl:with-param name="current" select="$waarde"/>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>
                        <p class="waarde"><xsl:value-of select="string(.)"/></p>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="./self::vt:hoofdlijnaanduiding">
                    <xsl:attribute name="style" select="string('padding: 0pt;')"/>
                    <xsl:variable name="id" select="./vt:HoofdlijnRef/@xlink:href"/>
                    <xsl:choose>
                      <xsl:when test="$hoofdlijnaanduidingen[vt:identificatie=$id]">
                        <xsl:call-template name="object">
                          <xsl:with-param name="check" select="$check"/>
                          <xsl:with-param name="current" select="$hoofdlijnaanduidingen[vt:identificatie=$id]"/>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:call-template name="error">
                          <xsl:with-param name="message" select="concat($id,' verwijst niet naar een object')"/>
                        </xsl:call-template>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="./self::vt:kaartaanduiding">
                    <xsl:attribute name="style" select="string('padding: 0pt;')"/>
                    <xsl:variable name="id" select="./k:KaartRef/@xlink:href"/>
                    <xsl:choose>
                      <xsl:when test="$kaarten[k:identificatie=$id]">
                        <xsl:call-template name="object">
                          <xsl:with-param name="check" select="$check"/>
                          <xsl:with-param name="current" select="$kaarten[k:identificatie=$id]"/>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:call-template name="error">
                          <xsl:with-param name="message" select="concat($id,' verwijst niet naar een object')"/>
                        </xsl:call-template>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="./self::k:uitsnede">
                    <xsl:attribute name="style" select="string('padding: 0pt;')"/>
                    <xsl:call-template name="object">
                      <xsl:with-param name="check" select="$check"/>
                      <xsl:with-param name="current" select="./k:Kaartextent"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="./self::k:kaartlagen">
                    <xsl:attribute name="style" select="string('padding: 0pt;')"/>
                    <xsl:call-template name="object">
                      <xsl:with-param name="check" select="$check"/>
                      <xsl:with-param name="current" select="./k:Kaartlaag"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <p class="waarde"><xsl:value-of select="string(.)"/></p>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </xsl:for-each>
  </xsl:template>

  <!-- block -->

  <xsl:template match="RegelingOpschrift" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <p class="titel"><xsl:apply-templates select="./Al/node()"/></p>
  </xsl:template>

  <xsl:template match="Kop" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:choose>
      <xsl:when test="fn:string-join(./element(),'') ne ''">
        <xsl:variable name="id" select="generate-id(.)"/>
        <xsl:variable name="level" select="count(ancestor::ArtikelgewijzeToelichting|ancestor::AlgemeneToelichting|ancestor::Bijlage|ancestor::Divisie|ancestor::Divisietekst|ancestor::InleidendeTekst|ancestor::Toelichting)"/>
        <p class="{if ($level gt 0) then fn:string-join(('kop',$level),'_') else string('kop')}" id="{$id}"><span class="nummer"><xsl:value-of select="fn:string-join((./Label,./Nummer),' ')"/></span><xsl:apply-templates select="./Opschrift/node()"/></p>
      </xsl:when>
      <xsl:otherwise>
        <!-- doe niets -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="Al|Wat" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <p class="standaard"><xsl:apply-templates select="./node()"/></p>
  </xsl:template>

  <xsl:template match="Gereserveerd" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <p class="standaard"><xsl:value-of select="string('[Gereserveerd]')"/></p>
  </xsl:template>

  <xsl:template match="Tussenkop" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <p class="tussenkop"><xsl:apply-templates select="./node()"/></p>
  </xsl:template>

  <xsl:template match="LidNummer" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <p class="lidnummer"><xsl:apply-templates select="./node()"/></p>
  </xsl:template>

  <!-- inline -->

  <xsl:template match="b" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <span class="vet"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="i" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <span class="cursief"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="u" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <span class="onderstreept"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="sup" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <span class="superscript"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="sub" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <span class="subscript"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="ExtRef" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <a href="{@doc}" target="_blank">
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <!--
  <xsl:template match="IntRef" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:variable name="idref" select="@idref"/>
    <xsl:variable name="check" select="generate-id(ancestor::Lichaam//*[@id=$idref])"/>
    <xsl:variable name="id" select="$TOC/*[@id=$check]"/>
    <xsl:choose>
      <xsl:when test="$id">
        <a href="{concat('lichaam_',fn:format-number(count($TOC/*[@id=$check]/preceding-sibling::*[@level='1']),'00'),'.html#',$id/@id)}">
          <xsl:apply-templates/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  -->

  <!-- tekens -->

  <xsl:template match="br" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <br/>
  </xsl:template>

  <!-- opsomming -->

  <xsl:template match="Lijst" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <div class="nummering">
      <xsl:apply-templates select="*"/>
    </div>
  </xsl:template>

  <xsl:template match="Lijstaanhef" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <p class="standaard"><xsl:value-of select="./node()"/></p>
  </xsl:template>

  <xsl:template match="Li" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <div class="item">
      <xsl:apply-templates select="element()"/>
    </div>
  </xsl:template>

  <xsl:template match="LiNummer" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <div class="nummer"><p class="standaard"><xsl:value-of select="."/></p></div>
  </xsl:template>

  <!-- begrippenlijst -->

  <xsl:template match="Begrippenlijst" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <div class="begrippenlijst">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="Begrip" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <div class="begrip">
      <xsl:apply-templates select="Term"/>
      <xsl:apply-templates select="Definitie"/>
    </div>
  </xsl:template>

  <xsl:template match="Term" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <p class="term"><xsl:apply-templates select="./node()"/></p>
  </xsl:template>

  <xsl:template match="Definitie" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:apply-templates select="./node()"/>
  </xsl:template>

  <!-- tabel -->

  <xsl:template match="table" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <table class="standaard">
      <xsl:apply-templates select="*"/>
    </table>
  </xsl:template>

  <xsl:template match="table/title" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <caption>
      <xsl:apply-templates select="./node()"/>
    </caption>
  </xsl:template>

  <xsl:template match="tgroup" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:variable name="default" select="100 div count(./colspec)"/>
    <xsl:variable name="col">
      <xsl:for-each select="./colspec" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
        <xsl:element name="width">
          <xsl:value-of select="(fn:tokenize(./@colwidth,'\*')[1],$default)[1]"/>
        </xsl:element>
      </xsl:for-each>
    </xsl:variable>
    <colgroup>
      <xsl:for-each select="$col/width" xpath-default-namespace="">
        <col style="{concat('width: ',. div sum($col/width) * 100,'%')}"/>
      </xsl:for-each>
    </colgroup>
    <xsl:apply-templates select="./thead"/>
    <xsl:apply-templates select="./tbody"/>
  </xsl:template>

  <xsl:template match="thead" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <thead>
      <xsl:apply-templates select="*"/>
    </thead>
  </xsl:template>

  <xsl:template match="tbody" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <tbody>
      <xsl:apply-templates select="*"/>
    </tbody>
  </xsl:template>

  <xsl:template match="row" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <tr>
      <xsl:apply-templates select="*"/>
    </tr>
  </xsl:template>

  <xsl:template match="entry" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:variable name="colspan" select="number(substring(./@nameend,4))-number(substring(./@namest,4))+1"/>
    <xsl:variable name="rowspan" select="number(./(@morerows,'0')[1])+1"/>
    <xsl:choose>
      <xsl:when test="ancestor::thead" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
        <th colspan="{$colspan}" rowspan="{$rowspan}" style="{concat('text-align:',./@align)}">
          <xsl:apply-templates select="*"/>
        </th>
      </xsl:when>
      <xsl:when test="ancestor::tbody" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
        <td colspan="{$colspan}" rowspan="{$rowspan}" style="{concat('text-align:',./@align)}">
          <xsl:apply-templates select="*"/>
        </td>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- figuur -->

  <xsl:template match="Figuur" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:variable name="width">
      <xsl:variable name="sum" select="fn:sum(Illustratie/number(@breedte)) div $factor"/>
      <xsl:choose>
        <xsl:when test="$sum lt 75">
          <xsl:value-of select="$sum"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="100"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="float">
      <xsl:choose>
        <xsl:when test="(./@dso:tekstomloop='ja')">
          <xsl:choose>
            <xsl:when test="./@dso:uitlijning=('links','rechts')">
              <xsl:value-of select="string(./@uitlijning)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="string('geen')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="string('geen')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <div class="{fn:string-join(('figuur',$float),' ')}" style="{concat('width: ',$width,'%')}">
      <xsl:apply-templates select="*"/>
    </div>
  </xsl:template>

  <xsl:template match="Figuur/Illustratie" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <img class="figuur" src="{concat('media/',./@naam)}" width="100%" alt="{(./@alt,./@naam)[1]}"/>
  </xsl:template>

  <xsl:template match="Figuur/Bijschrift" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <p class="bijschrift"><xsl:apply-templates select="./node()"/></p>
  </xsl:template>

  <!-- voetnoot -->

  <xsl:template match="Noot" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <a class="noot"><xsl:value-of select="concat('[',NootNummer,']')"/><span class="noottekst"><xsl:apply-templates select="Al/node()"/><xsl:text> </xsl:text></span></a>
  </xsl:template>

  <!-- functies -->

  <xsl:function name="my:value-to-mm" as="xs:decimal">
    <xsl:param name="value"/>
    <xsl:variable name="units" select="('twip','cm','in','mm','pt','px')"/>
    <xsl:variable name="twips" select="(0.0176388889,10,25.4,1,0.3527777778,0.2645833333)"/>
    <xsl:variable name="unit" select="($units[contains($value,.)],$units[1])[1]"/>
    <xsl:value-of select="number(fn:tokenize($value,$unit)[1]) * $twips[fn:index-of($units,$unit)]"/>
  </xsl:function>

  <xsl:function name="my:value-to-pt" as="xs:decimal">
    <xsl:param name="value"/>
    <xsl:variable name="units" select="('twip','cm','in','mm','pt','px')"/>
    <xsl:variable name="twips" select="(0.05,28.346456693,72,2.834645669,1,0.752929)"/>
    <xsl:variable name="unit" select="($units[contains($value,.)],$units[1])[1]"/>
    <xsl:value-of select="number(fn:tokenize($value,$unit)[1]) * $twips[fn:index-of($units,$unit)]"/>
  </xsl:function>

</xsl:stylesheet>