<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0" xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:k="http://www.geostandaarden.nl/imow/kaart" xmlns:l="http://www.geostandaarden.nl/imow/locatie" xmlns:r="http://www.geostandaarden.nl/imow/regels" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="#all">
  <xsl:output method="xhtml" encoding="UTF-8" indent="no" omit-xml-declaration="yes" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
  <xsl:strip-space elements="*"/>

  <xsl:param name="opdracht.dir" select="'C:/Werkbestanden/Geonovum/Overzicht/opdracht'"/>
  <xsl:param name="besluit" select="collection(concat('file:/',$opdracht.dir,'?select=*.xml;recurse=yes'))/AanleveringBesluit" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"/>
  <xsl:param name="regelteksten" select="collection(concat('file:/',$opdracht.dir,'?select=*.xml;recurse=yes'))//r:Regeltekst"/>
  <xsl:param name="regels" select="collection(concat('file:/',$opdracht.dir,'?select=*.xml;recurse=yes'))//(r:Instructieregel,r:Omgevingswaarderegel,r:RegelVoorIedereen)"/>
  <xsl:param name="locaties" select="collection(concat('file:/',$opdracht.dir,'?select=*.xml;recurse=yes'))//(l:Gebiedengroep,l:Gebied)"/>
  <xsl:param name="activiteiten" select="collection(concat('file:/',$opdracht.dir,'?select=*.xml;recurse=yes'))//rol:Activiteit"/>
  <xsl:param name="gebiedsaanwijzingen" select="collection(concat('file:/',$opdracht.dir,'?select=*.xml;recurse=yes'))//ga:Gebiedsaanwijzing"/>
  <xsl:param name="omgevingsnormaanduidingen" select="collection(concat('file:/',$opdracht.dir,'?select=*.xml;recurse=yes'))//rol:Omgevingsnorm"/>
  <xsl:param name="omgevingswaardeaanduidingen" select="collection(concat('file:/',$opdracht.dir,'?select=*.xml;recurse=yes'))//rol:Omgevingswaarde"/>
  <xsl:param name="divisies" select="collection(concat('file:/',$opdracht.dir,'?select=*.xml;recurse=yes'))//vt:Divisie"/>
  <xsl:param name="tekstdelen" select="collection(concat('file:/',$opdracht.dir,'?select=*.xml;recurse=yes'))//vt:Tekstdeel"/>
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

  <xsl:param name="waardelijsten" select="document('waardelijsten OP 1.0.4.xml')//Waardelijst"/>

  <xsl:template match="/">
    <html>
      <head>
        <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
        <link rel="stylesheet" type="text/css" href="overzicht.css"/>
        <title>
          <xsl:apply-templates select="$besluit//BesluitMetadata/officieleTitel/node()" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
        </title>
      </head>
      <body>
        <script type="text/javascript">function ShowHide(obj){var tbody = obj.parentNode.getElementsByTagName("tbody")[0];var old = tbody.style.display;tbody.style.display = (old == "none"?"":"none");}</script>
        <h1>AanleveringBesluit</h1>
        <xsl:apply-templates select="$besluit/BesluitVersie" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"/>
        <xsl:apply-templates select="$besluit//(BesluitCompact|BesluitKlassiek)//(RegelingCompact|RegelingKlassiek|RegelingTijdelijkdeel|RegelingVrijetekst|RegelingMutatie)" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="BesluitVersie" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/">
    <h2>Besluit</h2>
    <xsl:apply-templates select="ExpressionIdentificatie" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
    <xsl:apply-templates select="BesluitMetadata" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
    <xsl:apply-templates select="Procedureverloop" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
    <xsl:apply-templates select="ConsolidatieInformatie/BeoogdeRegelgeving" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
    <xsl:apply-templates select="ConsolidatieInformatie/Tijdstempels" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
  </xsl:template>

  <xsl:template match="RegelingCompact|RegelingKlassiek|RegelingTijdelijkdeel|RegelingVrijetekst|RegelingMutatie" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <h2>Regeling</h2>
    <xsl:if test=".//Artikel" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
      <div class="content">
        <table>
          <colgroup>
            <col width="165px"/>
            <col width="auto"/>
          </colgroup>
          <thead onclick="ShowHide(this)">
            <tr>
              <th colspan="2"><p class="titel">Artikel of lid</p></th>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each select=".//(Artikel[not(Lid)]|Lid)" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
              <xsl:variable name="wId" select="@wId"/>
              <xsl:variable name="ref" select=".//IntIoRef/@ref"/>
              <xsl:variable name="join-id">
                <xsl:for-each select="root()//ExtIoRef[@wId=$ref]">
                  <xsl:element name="BeoogdInformatieobject">
                    <xsl:value-of select="."/>
                  </xsl:element>
                </xsl:for-each>
              </xsl:variable>
              <xsl:variable name="regeltekst" select="$regelteksten[@wId=$wId]"/>
              <xsl:variable name="regel" select="$regels[r:artikelOfLid/r:RegeltekstRef/@xlink:href=$regeltekst/r:identificatie]"/>
              <tr>
                <td>
                  <xsl:choose>
                    <xsl:when test="self::Artikel">
                      <p class="naam"><xsl:value-of select="fn:string-join((Kop/(Label,Nummer)),' ')"/></p>
                    </xsl:when>
                    <xsl:when test="self::Lid">
                      <p class="naam"><xsl:value-of select="fn:string-join((fn:string-join((ancestor-or-self::Artikel/Kop/(Label,Nummer)),' '),fn:string-join(('Lid',LidNummer),' ')),', ')"/></p>
                    </xsl:when>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:call-template name="waarde">
                    <xsl:with-param name="current" select="ancestor-or-self::Artikel/Kop/Opschrift,@wId,$join-id" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
                  </xsl:call-template>
                  <xsl:call-template name="object">
                    <xsl:with-param name="current" select="$regel"/>
                  </xsl:call-template>
                </td>
              </tr>
            </xsl:for-each>
          </tbody>
        </table>
      </div>
    </xsl:if>
    <xsl:if test=".//Divisie" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
      <div class="content">
        <table>
          <colgroup>
            <col width="165px"/>
            <col width="auto"/>
          </colgroup>
          <thead onclick="ShowHide(this)">
            <tr>
              <th colspan="2"><p class="titel">Divisie</p></th>
            </tr>
          </thead>
          <tbody>
            <xsl:call-template name="divisie">
              <xsl:with-param name="node-list" select=".//(Bijlage|Toelichting|AlgemeneToelichting|ArtikelgewijzeToelichting|Lichaam/(Divisie|InleidendeTekst|Divisietekst))[string(Kop) ne '']"/>
            </xsl:call-template>
          </tbody>
        </table>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template name="divisie">
    <xsl:param name="node-list"/>
    <xsl:for-each select="$node-list" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
      <xsl:variable name="wId" select="@wId"/>
      <xsl:variable name="ref" select=".//IntIoRef[ancestor::element()[Divisie|InleidendeTekst|Divisietekst][1][@wId=$wId]]/@ref"/>
      <xsl:variable name="divisie" select="$divisies[@wId=$wId]"/>
      <xsl:variable name="tekstdeel" select="$tekstdelen[vt:divisieaanduiding/vt:DivisieRef/@xlink:href=$divisie/vt:identificatie]"/>
      <tr>
        <td>
          <p class="naam"><xsl:value-of select="fn:string-join((Kop/(Label,Nummer,Opschrift)),' ')"/></p>
        </td>
        <td>
          <xsl:call-template name="waarde">
            <xsl:with-param name="current">
              <xsl:element name="wId">
                <xsl:value-of select="@wId"/>
              </xsl:element>
              <xsl:element name="kruimelpad">
                <xsl:value-of select="fn:string-join(ancestor-or-self::element()[Divisie|InleidendeTekst|Divisietekst][string(Kop) ne '']/Kop/Opschrift,'|')" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
              </xsl:element>
              <xsl:for-each select="root()//ExtIoRef[@wId=$ref]">
                <xsl:element name="BeoogdInformatieobject">
                  <xsl:value-of select="."/>
                </xsl:element>
              </xsl:for-each>
            </xsl:with-param>
          </xsl:call-template>
          <xsl:call-template name="object">
            <xsl:with-param name="current" select="$tekstdeel"/>
          </xsl:call-template>
        </td>
      </tr>
      <xsl:call-template name="divisie">
        <xsl:with-param name="node-list" select="./(Divisie|InleidendeTekst|Divisietekst)[string(Kop) ne '']"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="waarde">
    <xsl:param name="current"/>
    <xsl:choose>
      <xsl:when test="$current/self::element()|$current/self::attribute()|$current/element()">
        <xsl:attribute name="style" select="string('padding: 0pt;')"/>
        <table>
          <colgroup>
            <col width="165px"/>
            <col width="auto"/>
          </colgroup>
          <tbody>
            <xsl:for-each select="$current/descendant-or-self::element()[text()|attribute()]|$current/self::attribute()">
              <tr>
                <td>
                  <p class="naam"><xsl:value-of select="./name()"/></p>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="./@xlink:href">
                      <p class="waarde"><xsl:value-of select="./@xlink:href"/></p>
                    </xsl:when>
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
        <xsl:variable name="label" select="$waardelijsten//Waarde[id=$waarde]/label"/>
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

  <xsl:template name="object">
    <xsl:param name="current"/>
    <xsl:for-each select="$current/self::element()">
      <table>
        <colgroup>
          <col width="165px"/>
          <col width="auto"/>
        </colgroup>
        <thead onclick="ShowHide(this)">
          <tr>
            <th colspan="2"><p class="titel"><xsl:value-of select="./local-name()"/></p></th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="(./element()|attribute())">
            <tr>
              <td><p class="naam"><xsl:value-of select="./local-name()"/></p></td>
              <td>
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
                          <xsl:with-param name="current" select="$gml/gio/Locatie[geo-id=$id]"/>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>
                        <p class="waarde"><span class="error"><xsl:value-of select="concat($id,' verwijst niet naar een object')"/></span></p>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="./self::r:locatieaanduiding|./self::rol:locatieaanduiding|./self::ga:locatieaanduiding|./self::vt:locatieaanduiding">
                    <xsl:attribute name="style" select="string('padding: 0pt;')"/>
                    <xsl:variable name="id" select="./l:LocatieRef/@xlink:href"/>
                    <xsl:choose>
                      <xsl:when test="$locaties[l:identificatie=$id]">
                        <xsl:call-template name="object">
                          <xsl:with-param name="current" select="$locaties[l:identificatie=$id]"/>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>
                        <p class="waarde"><span class="error"><xsl:value-of select="concat($id,' verwijst niet naar een object')"/></span></p>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="./self::l:groepselement">
                    <xsl:attribute name="style" select="string('padding: 0pt;')"/>
                    <xsl:variable name="id" select="./l:GebiedRef/@xlink:href"/>
                    <xsl:choose>
                      <xsl:when test="$locaties[l:identificatie=$id]">
                        <xsl:call-template name="object">
                          <xsl:with-param name="current" select="$locaties[l:identificatie=$id]"/>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>
                        <p class="waarde"><span class="error"><xsl:value-of select="concat($id,' verwijst niet naar een object')"/></span></p>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="./self::r:activiteitaanduiding">
                    <xsl:attribute name="style" select="string('padding: 0pt;')"/>
                    <xsl:variable name="id" select="./rol:ActiviteitRef/@xlink:href"/>
                    <xsl:choose>
                      <xsl:when test="$activiteiten[rol:identificatie=$id]">
                        <xsl:call-template name="object">
                          <xsl:with-param name="current" select="$activiteiten[rol:identificatie=$id]"/>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>
                        <p class="waarde"><span class="error"><xsl:value-of select="concat($id,' verwijst niet naar een object')"/></span></p>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:call-template name="object">
                      <xsl:with-param name="current" select="./r:ActiviteitLocatieaanduiding"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="./self::rol:gerelateerdeActiviteit|./self::rol:bovenliggendeActiviteit">
                    <xsl:attribute name="style" select="string('padding: 0pt;')"/>
                    <xsl:variable name="activiteit-id" select="./rol:ActiviteitRef/@xlink:href"/>
                    <xsl:for-each select="$activiteit-id">
                      <xsl:variable name="id" select="string(.)"/>
                      <xsl:choose>
                        <xsl:when test="$activiteiten[rol:identificatie=$id]">
                          <xsl:call-template name="object">
                            <xsl:with-param name="current" select="$activiteiten[rol:identificatie=$id]"/>
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
                      <xsl:when test="$gebiedsaanwijzingen[ga:identificatie=$id]">
                        <xsl:call-template name="object">
                          <xsl:with-param name="current" select="$gebiedsaanwijzingen[ga:identificatie=$id]"/>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>
                        <p class="waarde"><span class="error"><xsl:value-of select="concat($id,' verwijst niet naar een object')"/></span></p>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="./self::r:omgevingsnormaanduiding">
                    <xsl:attribute name="style" select="string('padding: 0pt;')"/>
                    <xsl:variable name="id" select="./rol:OmgevingsnormRef/@xlink:href"/>
                    <xsl:choose>
                      <xsl:when test="$omgevingsnormaanduidingen[rol:identificatie=$id]">
                        <xsl:call-template name="object">
                          <xsl:with-param name="current" select="$omgevingsnormaanduidingen[rol:identificatie=$id]"/>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>
                        <p class="waarde"><span class="error"><xsl:value-of select="concat($id,' verwijst niet naar een object')"/></span></p>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="./self::r:omgevingswaardeaanduiding">
                    <xsl:attribute name="style" select="string('padding: 0pt;')"/>
                    <xsl:variable name="id" select="./rol:OmgevingswaardeRef/@xlink:href"/>
                    <xsl:choose>
                      <xsl:when test="$omgevingswaardeaanduidingen[rol:identificatie=$id]">
                        <xsl:call-template name="object">
                          <xsl:with-param name="current" select="$omgevingswaardeaanduidingen[rol:identificatie=$id]"/>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>
                        <p class="waarde"><span class="error"><xsl:value-of select="concat($id,' verwijst niet naar een object')"/></span></p>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="./self::rol:normwaarde">
                    <xsl:attribute name="style" select="string('padding: 0pt;')"/>
                    <xsl:call-template name="object">
                      <xsl:with-param name="current" select="./rol:Normwaarde"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="./self::rol:kwantitatieveWaarde">
                    <xsl:attribute name="style" select="string('padding: 0pt;')"/>
                    <xsl:variable name="locatie-id" select="$current//l:LocatieRef/@xlink:href"/>
                    <xsl:variable name="gebied-id" select="$locaties[l:identificatie=$locatie-id]//l:GeometrieRef/@xlink:href"/>
                    <xsl:variable name="waarde" select="$gml/gio[Locatie/geo-id=$gebied-id]/Waarde"/>
                    <xsl:choose>
                      <xsl:when test="$waarde">
                        <xsl:call-template name="object">
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
                          <xsl:with-param name="current" select="$hoofdlijnaanduidingen[vt:identificatie=$id]"/>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>
                        <p class="waarde"><span class="error"><xsl:value-of select="concat($id,' verwijst niet naar een object')"/></span></p>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="./self::vt:kaartaanduiding">
                    <xsl:attribute name="style" select="string('padding: 0pt;')"/>
                    <xsl:variable name="id" select="./k:KaartRef/@xlink:href"/>
                    <xsl:choose>
                      <xsl:when test="$kaarten[k:identificatie=$id]">
                        <xsl:call-template name="object">
                          <xsl:with-param name="current" select="$kaarten[k:identificatie=$id]"/>
                        </xsl:call-template>
                      </xsl:when>
                      <xsl:otherwise>
                        <p class="waarde"><span class="error"><xsl:value-of select="concat($id,' verwijst niet naar een object')"/></span></p>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:when test="./self::k:uitsnede">
                    <xsl:attribute name="style" select="string('padding: 0pt;')"/>
                    <xsl:call-template name="object">
                      <xsl:with-param name="current" select="./k:Kaartextent"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="./self::k:kaartlagen">
                    <xsl:attribute name="style" select="string('padding: 0pt;')"/>
                    <xsl:call-template name="object">
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

  <xsl:template match="ExpressionIdentificatie" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <div class="content">
      <table>
        <colgroup>
          <col width="165px"/>
          <col width="auto"/>
        </colgroup>
        <thead onclick="ShowHide(this)">
          <tr>
            <th colspan="2"><p class="titel"><xsl:value-of select="./name()"/></p></th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="element()">
            <tr>
              <td>
                <p class="naam"><xsl:value-of select="./name()"/></p>
              </td>
              <td>
                <xsl:call-template name="waarde">
                  <xsl:with-param name="current" select="text(),element()"/>
                </xsl:call-template>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </div>
  </xsl:template>

  <xsl:template match="BesluitMetadata" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <div class="content">
      <table>
        <colgroup>
          <col width="165px"/>
          <col width="auto"/>
        </colgroup>
        <thead onclick="ShowHide(this)">
          <tr>
            <th colspan="2"><p class="titel"><xsl:value-of select="./name()"/></p></th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="eindverantwoordelijke,maker,officieleTitel,heeftCiteertitelInformatie//citeertitel,onderwerpen/onderwerp,rechtsgebieden/rechtsgebied,soortProcedure,informatieobjectRefs/informatieobjectRef" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
            <tr>
              <td>
                <p class="naam"><xsl:value-of select="./name()"/></p>
              </td>
              <td>
                <xsl:call-template name="waarde">
                  <xsl:with-param name="current" select="text(),element()"/>
                </xsl:call-template>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </div>
  </xsl:template>

  <xsl:template match="Procedureverloop" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <div class="content">
      <table>
        <colgroup>
          <col width="165px"/>
          <col width="auto"/>
        </colgroup>
        <thead onclick="ShowHide(this)">
          <tr>
            <th colspan="2"><p class="titel"><xsl:value-of select="./name()"/></p></th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="bekendOp,ontvangenOp,procedurestappen/Procedurestap" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
            <tr>
              <td>
                <p class="naam"><xsl:value-of select="./name()"/></p>
              </td>
              <td>
                <xsl:call-template name="waarde">
                  <xsl:with-param name="current" select="text(),element()"/>
                </xsl:call-template>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </div>
  </xsl:template>
  
  <xsl:template match="ConsolidatieInformatie/BeoogdeRegelgeving" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <div class="content">
      <table>
        <colgroup>
          <col width="165px"/>
          <col width="auto"/>
        </colgroup>
        <thead onclick="ShowHide(this)">
          <tr>
            <th colspan="2"><p class="titel"><xsl:value-of select="./name()"/></p></th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="element()" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
            <tr>
              <td>
                <p class="naam"><xsl:value-of select="./name()"/></p>
              </td>
              <td>
                <xsl:call-template name="waarde">
                  <xsl:with-param name="current" select="text(),element()"/>
                </xsl:call-template>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </div>
  </xsl:template>

  <xsl:template match="ConsolidatieInformatie/Tijdstempels" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <div class="content">
      <table>
        <colgroup>
          <col width="165px"/>
          <col width="auto"/>
        </colgroup>
        <thead onclick="ShowHide(this)">
          <tr>
            <th colspan="2"><p class="titel"><xsl:value-of select="./name()"/></p></th>
          </tr>
        </thead>
        <tbody>
          <xsl:for-each select="element()" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
            <tr>
              <td>
                <p class="naam"><xsl:value-of select="./name()"/></p>
              </td>
              <td>
                <xsl:call-template name="waarde">
                  <xsl:with-param name="current" select="text(),element()"/>
                </xsl:call-template>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>
      </table>
    </div>
  </xsl:template>

</xsl:stylesheet>