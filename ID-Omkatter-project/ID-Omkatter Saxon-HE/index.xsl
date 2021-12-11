<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" xmlns:ow="http://www.geostandaarden.nl/imow/owobject"
  xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" xmlns:k="http://www.geostandaarden.nl/imow/kaart"
  xmlns:l="http://www.geostandaarden.nl/imow/locatie" xmlns:p="http://www.geostandaarden.nl/imow/pons" xmlns:r="http://www.geostandaarden.nl/imow/regels"
  xmlns:rg="http://www.geostandaarden.nl/imow/regelingsgebied" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:gml="http://www.opengis.net/gml/3.2"
  xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0" xmlns:lvbb="http://www.overheid.nl/2017/lvbb" xmlns:lvbb_intern="http://www.overheid.nl/2020/lvbb/intern"
  xmlns:aanlevering="https://standaarden.overheid.nl/lvbb/stop/aanlevering/" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/"
  xmlns:manifest-ow="http://www.geostandaarden.nl/bestanden-ow/manifest-ow" xmlns:lvbbu="https://standaarden.overheid.nl/lvbb/stop/uitlevering/" 
  xmlns:s="http://www.geostandaarden.nl/imow/symbolisatie">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
  <xsl:strip-space elements="*"/>

  <!-- file.list bevat alle te verwerken bestanden -->

  <xsl:param name="file.list" as="xs:string*"/>
  <xsl:param name="base.dir"/>
  <xsl:param name="bron.dir"/>
  <xsl:param name="alreadyRetrievedDateTime"/>
  <xsl:param name="guid.list"/>
  <xsl:param name="bronnummer" as="xs:integer"/>

  <xsl:template match="/">
    <!-- 'bron' is vervangen door 'bron_0' -->
    <xsl:variable name="directory" select="concat($base.dir,'/bron_',$bronnummer)"/>
    <xsl:element name="index">
      <xsl:element name="alreadyRetrievedDateTime">
        <xsl:value-of select="$alreadyRetrievedDateTime"/>
      </xsl:element>
      <!-- controleer op consolidaties -->
      <xsl:if test="collection(concat($directory,'?select=*.xml'))/lvbbu:Consolidaties">
        <xsl:element name="consolidatie">
          <xsl:value-of select="1"/>
        </xsl:element>
      </xsl:if>
      <!-- plaats FRBRWork van originele regeling -->
      <xsl:if test="collection(concat($directory,'?select=*.xml'))/aanlevering:AanleveringBesluit">
        <xsl:for-each select="for $index in 0 to $bronnummer return $index">
          <xsl:variable name="directory" select="concat($base.dir,'/bron_',.)"/>
          <xsl:for-each select="collection(concat($directory,'?select=*.xml'))/aanlevering:AanleveringBesluit/aanlevering:RegelingVersieInformatie/data:ExpressionIdentificatie/data:FRBRWork">
            <xsl:variable name="object" select="."/>
            <xsl:element name="regeling">
              <xsl:element name="origineleregelingFRBRWork">
                <xsl:value-of select="$object/text()"/>
              </xsl:element>
            </xsl:element>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:if>
      <!-- historische informatieobjectRefs voor verwerking in extiorefs die geen informatieobjectRefs in actueel besluit hebben -->
      <xsl:if test="collection(concat($directory,'?select=*.xml'))/aanlevering:AanleveringBesluit">
        <xsl:for-each select="for $index in 0 to $bronnummer return $index">
          <xsl:variable name="directory" select="concat($base.dir,'/bron_',.)"/>
          <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//data:BesluitMetadata/data:informatieobjectRefs/data:informatieobjectRef">
            <xsl:variable name="object" select="."/>
            <xsl:element name="historischInformatieobjectRef">
              <xsl:element name="oldIoWorkId">
                <xsl:value-of select="concat('/',tokenize($object/text(),'/')[2],'/',tokenize($object/text(),'/')[3],'/',tokenize($object/text(),'/')[4],'/',tokenize($object/text(),'/')[5],'/',tokenize($object/text(),'/')[6],'/',tokenize($object/text(),'/')[7])"/>
              </xsl:element>
              <xsl:element name="oldIoRefId">
                <xsl:value-of select="$object/text()"/>
              </xsl:element>
            </xsl:element>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:if>
      <!-- informatieobjectRefs en gerelateerde bestanden -->
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))/aanlevering:AanleveringBesluit">
        <xsl:variable name="besluit" select="."/>
        <xsl:element name="besluit">
          <xsl:for-each select="$besluit//data:BesluitMetadata/data:informatieobjectRefs/data:informatieobjectRef">
            <xsl:variable name="object" select="."/>
            <xsl:element name="informatieobjectRef">
              <xsl:for-each select="collection(concat($directory,'?select=*.xml'))/aanlevering:AanleveringInformatieObject[//data:FRBRExpression=$object/text()]">
                <xsl:variable name="object" select="."/>
                <xsl:variable name="type" select="$object//data:InformatieObjectMetadata/data:formaatInformatieobject"/>
                <xsl:choose>
                  <xsl:when test="$type='/join/id/stop/informatieobject/gio_002'">
                    <xsl:element name="gio">
                      <xsl:value-of select="tokenize(base-uri($object),'/')[last()]"/>
                    </xsl:element>
                    <xsl:element name="gml">
                      <xsl:value-of select="$object//data:Bestand/data:bestandsnaam"/>
                    </xsl:element>
                  </xsl:when>
                  <xsl:when test="$type='/join/id/stop/informatieobject/doc_001'">
                    <xsl:element name="doc">
                      <xsl:value-of select="tokenize(base-uri($object),'/')[last()]"/>
                    </xsl:element>
                    <xsl:element name="pdf">
                      <xsl:value-of select="$object//data:Bestand/data:bestandsnaam"/>
                    </xsl:element>
                  </xsl:when>
                </xsl:choose>
              </xsl:for-each>
              <xsl:element name="oldIoWorkId">
                <xsl:value-of select="concat('/',tokenize($object/text(),'/')[2],'/',tokenize($object/text(),'/')[3],'/',tokenize($object/text(),'/')[4],'/',tokenize($object/text(),'/')[5],'/',tokenize($object/text(),'/')[6],'/',tokenize($object/text(),'/')[7])"/>
              </xsl:element>
              <xsl:element name="oldIoRefId">
                <xsl:value-of select="$object/text()"/>
              </xsl:element>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:for-each>
      <!-- Levering Ids -->
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//(lvbb:idLevering|lvbb_intern:idLevering)">
        <xsl:variable name="levering" select="."/>
        <xsl:element name="leveringId">
          <xsl:attribute name="sourcefile" select="tokenize(base-uri($levering),'/')[last()]"/>
          <xsl:for-each select="collection(concat($directory,'?select=*.xml'))/ow-dc:owBestand[//sl:leveringsId]">
            <xsl:variable name="object" select="."/>
            <xsl:element name="referencefile">
              <xsl:value-of select="tokenize(base-uri($object),'/')[last()]"/>
            </xsl:element>
          </xsl:for-each>
          <xsl:element name="new">
            <xsl:value-of select="concat($levering/text(),'-',$alreadyRetrievedDateTime)"/>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
      <!-- GUIDS -->
      <xsl:variable name="guids" select="collection(concat($directory,'?select=*.gml'))/geo:GeoInformatieObjectVaststelling//basisgeo:id"/>
      <xsl:if test="$guids">
        <xsl:element name="guids">
          <xsl:for-each select="$guids">
            <xsl:variable name="index" select="position()"/>
            <xsl:variable name="guid" select="."/>
            <xsl:variable name="locatiefile" select="collection(concat($directory,'?select=*.xml'))//l:GeometrieRef[@xlink:href = $guid/text()]/base-uri(.)"/>
            <xsl:choose>
              <xsl:when test="$locatiefile ne ''">
                <xsl:element name="guidInOw">
                  <xsl:attribute name="locatiefile" select="tokenize($locatiefile,'/')[last()]"/>
                  <xsl:attribute name="gmlfile" select="tokenize(base-uri($guid),'/')[last()]"/>
                  <xsl:element name="org">
                    <xsl:value-of select="$guid/text()"/>
                  </xsl:element>
                  <xsl:element name="new">
                    <xsl:value-of select="tokenize($guid.list,',')[$index]"/>
                  </xsl:element>
                </xsl:element>
              </xsl:when>
              <xsl:otherwise>
                <xsl:element name="guid">
                  <xsl:attribute name="gmlfile" select="tokenize(base-uri($guid),'/')[last()]"/>
                  <xsl:element name="org">
                    <xsl:value-of select="$guid/text()"/>
                  </xsl:element>
                  <xsl:element name="new">
                    <xsl:value-of select="tokenize($guid.list,',')[$index]"/>
                  </xsl:element>
                </xsl:element>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:element>
      </xsl:if>
      <!-- BESLUIT -->
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))/aanlevering:AanleveringBesluit">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'besluit.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'false'"/>
        </xsl:call-template>
      </xsl:for-each>
      <!-- OPDRACHT -->
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))/lvbb:publicatieOpdracht">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'opdracht.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'false'"/>
        </xsl:call-template>
      </xsl:for-each>
      <!-- GML -->
      <xsl:for-each select="collection(concat($directory,'?select=*.gml'))//geo:GeoInformatieObjectVaststelling">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'gml.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'false'"/>
        </xsl:call-template>
      </xsl:for-each>
      <!-- GIO -->
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//data:InformatieObjectMetadata[data:formaatInformatieobject='/join/id/stop/informatieobject/gio_002']">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'gio.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'false'"/>
        </xsl:call-template>
      </xsl:for-each>
      <!-- PDF -->
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//data:InformatieObjectMetadata[data:formaatInformatieobject='/join/id/stop/informatieobject/doc_001']">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'doc.pdf'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'false'"/>
        </xsl:call-template>
      </xsl:for-each>
      <!-- OW -->
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//ga:Gebiedsaanwijzing">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'gebiedsaanwijzing.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'true'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//k:Kaart">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'kaart.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'true'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//k:Kaartlaag">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'kaart.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'true'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//l:Ambtsgebied">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'locatie.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'true'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//l:Gebied">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'locatie.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'true'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//l:Gebiedengroep">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'locatie.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'true'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//l:Lijn">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'locatie.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'true'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//l:Lijnengroep">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'locatie.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'true'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//l:Punt">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'locatie.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'true'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//l:Puntengroep">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'locatie.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'true'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//l:Locatie">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'locatie.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'true'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//p:Pons">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'pons.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'true'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//rg:Regelingsgebied">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'regelingsgebied.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'true'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//r:ActiviteitLocatieaanduiding">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'regeltekst.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'true'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//r:Regeltekst">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'regeltekst.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'true'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//r:Instructieregel">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'regeltekst.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'true'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//r:Omgevingswaarderegel">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'regeltekst.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'true'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//r:RegelVoorIedereen">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'regeltekst.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'true'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//rol:Activiteit">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'activiteit.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'true'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//rol:Normwaarde">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'normwaarde.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'true'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//rol:Omgevingswaarde">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'normwaarde.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'true'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//rol:Omgevingsnorm">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'normwaarde.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'true'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//vt:Hoofdlijn">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'hoofdlijn.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'true'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//vt:Tekstdeel">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'tekstdeel.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'true'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//vt:Divisie">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'vrijetekst.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'true'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//s:SymbolisatieItem">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'symbolisatie.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'true'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//Aanleveringen" xpath-default-namespace="http://www.geostandaarden.nl/bestanden-ow/manifest-ow">
        <xsl:call-template name="file">
          <xsl:with-param name="type" select="'manifest-ow.xml'"/>
          <xsl:with-param name="fullname" select="base-uri(.)"/>
          <xsl:with-param name="ow" select="'false'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="distinct-values(collection(concat($directory,'?select=*.xml'))//rol:Activiteit/rol:bovenliggendeActiviteit/rol:ActiviteitRef/@xlink:href)">
        <xsl:variable name="id" select="."/>
        <xsl:variable name="activiteit" select="collection(concat($directory,'?select=*.xml'))//rol:Activiteit[rol:identificatie=$id]"/>
        <xsl:if test="$activiteit/self::rol:Activiteit">
          <xsl:element name="bovenliggendeActiviteitRelatie">
            <xsl:element name="name">
              <xsl:value-of select="tokenize(base-uri($activiteit),'/')[last()]"/>
            </xsl:element>
            <xsl:element name="bovenliggendeActiviteitIdLokaalAanwezig">
              <xsl:value-of select="$id"/>
            </xsl:element>
          </xsl:element>
        </xsl:if>
      </xsl:for-each>
      <xsl:for-each select="collection(concat($directory,'?select=*.xml'))//rol:Activiteit/rol:gerelateerdeActiviteit/rol:ActiviteitRef/@xlink:href">
        <xsl:variable name="id" select="."/>
        <xsl:variable name="activiteit" select="collection(concat($directory,'?select=*.xml'))//rol:Activiteit[rol:identificatie=$id]"/>
        <xsl:if test="$activiteit/self::rol:Activiteit">
          <xsl:element name="gerelateerdeActiviteitRelatie">
            <xsl:element name="name">
              <xsl:value-of select="tokenize(base-uri($activiteit),'/')[last()]"/>
            </xsl:element>
            <xsl:element name="gerelateerdeActiviteitIdLokaalAanwezig">
              <xsl:value-of select="$id"/>
            </xsl:element>
          </xsl:element>
        </xsl:if>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template name="file">
    <xsl:param name="type" as="xs:string"/>
    <xsl:param name="fullname" as="xs:string"/>
    <xsl:param name="ow" as="xs:string"/>
    <xsl:element name="file">
      <xsl:attribute name="type" select="$type"/>
      <xsl:attribute name="ow" select="$ow"/>
      <xsl:element name="name">
        <xsl:value-of select="tokenize($fullname,'/')[last()]"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
