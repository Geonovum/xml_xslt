<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" xmlns:r="http://www.geostandaarden.nl/imow/regels" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" xmlns:l="http://www.geostandaarden.nl/imow/locatie" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0" xmlns:rg="http://www.geostandaarden.nl/imow/regelingsgebied" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
  <xsl:strip-space elements="*"/>

  <xsl:param name="input.dir" select="string('file:/C:/Werkbestanden/Geonovum/open-omgevingswet/input')"/>
  <xsl:param name="temp.dir" select="string('file:/C:/Werkbestanden/Geonovum/open-omgevingswet/output')"/>

  <xsl:param name="besluit" select="collection(concat($input.dir,'/op?select=*.xml'))/AanleveringBesluit" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"/>
  <xsl:param name="excel" select="collection(concat($input.dir,'/ow?select=*.xml'))/Workbook" xpath-default-namespace="urn:schemas-microsoft-com:office:spreadsheet"/>
  <xsl:param name="waardelijsten" select="document('waardelijsten 1.0.3.xml')/waardelijsten"/>
  <xsl:param name="OIN" select="document('OIN.xml')"/>

  <xsl:param name="ID01" select="string($besluit//RegelingMetadata/eindverantwoordelijke)" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
  <xsl:param name="ID02" select="string(($besluit//ExpressionIdentificatie/FRBRWork)[2])" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
  <xsl:param name="ID03" select="fn:tokenize($ID01,'/')[last()]"/>

  <!-- temp_regelteksten is nodig om te controleren of er artikelen en onderliggende leden zijn geannoteerd -->
  <xsl:param name="temp_regelteksten">
    <xsl:for-each select="$excel/Worksheet[@ss:Name='Regels']/Table[1]/Row[position() gt 1][descendant::Data]" xpath-default-namespace="urn:schemas-microsoft-com:office:spreadsheet">
      <xsl:variable name="row">
        <xsl:call-template name="check_row">
          <xsl:with-param name="current" select="."/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="typeRegel" select="fn:index-of(('instructieregel','omgevingswaarderegel','regelvooriedereen'),lower-case(normalize-space($row/cell[5]/data)))" xpath-default-namespace=""/>
      <xsl:if test="$typeRegel gt 0">
        <xsl:variable name="art" select="if ($row/cell[3]/data) then fn:string-join(('art',$row/cell[3]/data),'_') else null" xpath-default-namespace=""/>
        <xsl:variable name="para" select="if ($row/cell[4]/data) then fn:string-join(('para',$row/cell[4]/data),'_') else null" xpath-default-namespace=""/>
        <xsl:variable name="id" select="fn:string-join(($art,$para),'__')"/>
        <xsl:if test="$id ne ''">
          <xsl:variable name="wId" select="$besluit//element()[fn:ends-with(@wId,$id)][1]/@wId"/>
          <xsl:if test="$wId ne ''">
            <xsl:element name="regeltekst">
              <xsl:attribute name="wId" select="$wId"/>
              <xsl:attribute name="art" select="$art"/>
              <xsl:if test="$para">
                <xsl:attribute name="para" select="$para"/>
              </xsl:if>
              <xsl:attribute name="art" select="$art"/>
              <xsl:element name="type">
                <xsl:value-of select="('Instructieregel','Omgevingswaarderegel','RegelVoorIedereen')[$typeRegel]"/>
              </xsl:element>
              <xsl:for-each select="for $index in 1 to 10 return $index">
                <xsl:variable name="index" select="."/>
                <xsl:variable name="data" select="$row/cell[$index+5]/data" xpath-default-namespace=""/>
                <xsl:if test="$data">
                  <xsl:for-each select="fn:tokenize($data,'[,;]')">
                    <xsl:variable name="name" select="('activiteitregelkwalificatie','locatie','idealisatie','activiteit','thema','norm','waarde','gebiedsaanwijzing','instructieregelinstrument','instructieregeltaakuitoefening')[$index]"/>
                    <xsl:element name="{$name}">
                      <xsl:choose>
                        <xsl:when test="$name=('activiteit','norm')">
                          <xsl:value-of select="normalize-space(.)"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="lower-case(normalize-space(.))"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:element>
                  </xsl:for-each>
                </xsl:if>
              </xsl:for-each>
            </xsl:element>
          </xsl:if>
        </xsl:if>
      </xsl:if>
    </xsl:for-each>
  </xsl:param>

  <!-- regelteksten bevat de opgeschoonde regelteksten -->
  <xsl:param name="regelteksten">
    <xsl:for-each-group select="$temp_regelteksten/regeltekst" group-by="./@art">
      <xsl:for-each select="current-group()[@para or (count(current-group()) eq 1)]">
        <xsl:copy-of select="."/>
      </xsl:for-each>
    </xsl:for-each-group>
  </xsl:param>

  <!-- temp_activiteiten is nodig om bovenliggende activiteiten toe te voegen -->
  <xsl:param name="temp_activiteiten">
    <xsl:for-each select="$excel/Worksheet[@ss:Name='Activiteiten']/Table[1]/Row[position() gt 1][descendant::Data]" xpath-default-namespace="urn:schemas-microsoft-com:office:spreadsheet">
      <xsl:variable name="row">
        <xsl:call-template name="check_row">
          <xsl:with-param name="current" select="."/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="id" select="normalize-space(($row/cell[1]/data,'onbekend')[1])" xpath-default-namespace=""/>
      <xsl:element name="activiteit">
        <xsl:element name="id">
          <xsl:value-of select="$id"/>
        </xsl:element>
        <xsl:element name="naam">
          <xsl:value-of select="lower-case(normalize-space(($row/cell[2]/data,'onbekend')[1]))" xpath-default-namespace=""/>
        </xsl:element>
        <xsl:element name="groep">
          <xsl:value-of select="lower-case(normalize-space(($row/cell[3]/data,'onbekend')[1]))" xpath-default-namespace=""/>
        </xsl:element>
        <xsl:for-each select="fn:tokenize(($row/cell[4]/data,'onbekend')[1],'[,;]')" xpath-default-namespace="">
          <xsl:element name="locatie">
            <xsl:value-of select="lower-case(normalize-space(.))"/>
          </xsl:element>
        </xsl:for-each>
        <xsl:element name="bovenliggende_activiteit">
          <!-- in eerste ronde alleen overnemen, in tweede ronde controleren -->
          <xsl:value-of select="normalize-space(($row/cell[5]/data,'onbekend')[1])" xpath-default-namespace=""/>
        </xsl:element>
        <xsl:if test="$row/cell[6]/data">
          <xsl:element name="gerelateerde_activiteit">
            <xsl:value-of select="normalize-space($row/cell[6]/data)" xpath-default-namespace=""/>
          </xsl:element>
        </xsl:if>
      </xsl:element>
    </xsl:for-each>
  </xsl:param>

  <!-- activiteiten bevat de opgeschoonde activiteiten -->
  <xsl:param name="activiteiten">
    <xsl:for-each-group select="$temp_activiteiten/activiteit" group-by="./id">
      <!-- hier controle regelteksten -->
      <xsl:if test="$regelteksten/regeltekst[activiteit=current-group()[1]/id]">
        <xsl:element name="activiteit">
          <xsl:copy-of select="current-group()[1]/element() except bovenliggende_activiteit"/>
          <xsl:element name="bovenliggende_activiteit">
            <xsl:value-of select="($temp_activiteiten/activiteit[./id=current-group()[1]/bovenliggende_activiteit]/id,'onbekend')[1]"/>
          </xsl:element>
        </xsl:element>
      </xsl:if>
    </xsl:for-each-group>
  </xsl:param>

  <!-- temp_normen bevat alle normen -->
  <xsl:param name="temp_normen">
    <xsl:for-each select="$excel/Worksheet[@ss:Name='Normen']/Table[1]/Row[position() gt 1][descendant::Data]" xpath-default-namespace="urn:schemas-microsoft-com:office:spreadsheet">
      <xsl:variable name="row">
        <xsl:call-template name="check_row">
          <xsl:with-param name="current" select="."/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="id" select="normalize-space($row/cell[1]/data)" xpath-default-namespace=""/>
      <xsl:element name="norm">
        <xsl:element name="id">
          <xsl:value-of select="$id"/>
        </xsl:element>
        <xsl:element name="naam">
          <xsl:value-of select="lower-case(normalize-space(($row/cell[2]/data,'onbekend')[1]))" xpath-default-namespace=""/>
        </xsl:element>
        <xsl:element name="groep">
          <xsl:value-of select="lower-case(normalize-space(($row/cell[3]/data,'onbekend')[1]))" xpath-default-namespace=""/>
        </xsl:element>
        <xsl:element name="type">
          <xsl:value-of select="lower-case(normalize-space(($row/cell[4]/data,'onbekend')[1]))" xpath-default-namespace=""/>
        </xsl:element>
        <xsl:element name="waarde">
          <xsl:value-of select="lower-case(normalize-space(($row/cell[5]/data,'onbekend')[1]))" xpath-default-namespace=""/>
        </xsl:element>
        <xsl:if test="$row/cell[5]/data" xpath-default-namespace="">
          <xsl:element name="eenheid">
            <xsl:value-of select="lower-case(normalize-space($row/cell[6]/data))" xpath-default-namespace=""/>
          </xsl:element>
        </xsl:if>
        <xsl:for-each select="fn:tokenize(($row/cell[7]/data,'onbekend')[1],'[,;]')" xpath-default-namespace="">
          <xsl:element name="locatie">
            <xsl:value-of select="lower-case(normalize-space(.))"/>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:for-each>
  </xsl:param>

  <!-- normen bevat de opgeschoonde normen -->
  <xsl:param name="normen">
    <xsl:for-each-group select="$temp_normen/norm" group-by="./id">
      <!-- hier controle regelteksten -->
      <xsl:if test="$regelteksten/regeltekst[norm=current-group()[1]/id]">
        <xsl:copy-of select="current-group()"/>
      </xsl:if>
    </xsl:for-each-group>
  </xsl:param>

  <!-- temp_gebiedsaanwijzingen bevat alle gebiedsaanwijzingen -->
  <xsl:param name="temp_gebiedsaanwijzingen">
    <xsl:for-each select="$excel/Worksheet[@ss:Name='Gebiedsaanwijzingen']/Table[1]/Row[position() gt 1][descendant::Data]" xpath-default-namespace="urn:schemas-microsoft-com:office:spreadsheet">
      <xsl:variable name="row">
        <xsl:call-template name="check_row">
          <xsl:with-param name="current" select="."/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="id" select="normalize-space($row/cell[1]/data)" xpath-default-namespace=""/>
      <xsl:element name="gebiedsaanwijzing">
        <xsl:element name="id">
          <xsl:value-of select="$id"/>
        </xsl:element>
        <xsl:element name="type">
          <xsl:value-of select="normalize-space(($row/cell[2]/data,'onbekend')[1])" xpath-default-namespace=""/>
        </xsl:element>
        <xsl:element name="naam">
          <xsl:value-of select="lower-case(normalize-space(($row/cell[3]/data,'onbekend')[1]))" xpath-default-namespace=""/>
        </xsl:element>
        <xsl:element name="groep">
          <xsl:value-of select="lower-case(normalize-space(($row/cell[4]/data,'onbekend')[1]))" xpath-default-namespace=""/>
        </xsl:element>
        <xsl:for-each select="fn:tokenize(($row/cell[5]/data,'onbekend')[1],'[,;]')" xpath-default-namespace="">
          <xsl:element name="locatie">
            <xsl:value-of select="lower-case(normalize-space(.))"/>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:for-each>
  </xsl:param>

  <!-- gebiedsaanwijzingen bevat de opgeschoonde gebiedsaanwijzingen -->
  <xsl:param name="gebiedsaanwijzingen">
    <xsl:for-each-group select="$temp_gebiedsaanwijzingen/gebiedsaanwijzing" group-by="./id">
      <!-- hier controle regelteksten -->
      <xsl:if test="$regelteksten/regeltekst[gebiedsaanwijzing=current-group()[1]/id]">
        <xsl:copy-of select="current-group()[1]"/>
      </xsl:if>
    </xsl:for-each-group>
  </xsl:param>

  <!-- hiertussen moeten alle objecten komen die locaties bevatten -->

  <!-- temp_locaties is nodig om te controleren of locaties niet dubbel zijn en of ze gebruikt worden in andere objecten -->
  <xsl:param name="temp_locaties">
    <xsl:for-each select="$excel/Worksheet[@ss:Name='Locaties']/Table[1]/Row[position() gt 1][descendant::Data]" xpath-default-namespace="urn:schemas-microsoft-com:office:spreadsheet">
      <xsl:variable name="row">
        <xsl:call-template name="check_row">
          <xsl:with-param name="current" select="."/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="id" select="lower-case(normalize-space($row/cell[1]/data))" xpath-default-namespace=""/>
      <xsl:variable name="gml.filename" select="lower-case(normalize-space(($row/cell[3]/data,'onbekend')[1]))" xpath-default-namespace=""/>
      <xsl:variable name="gml.file" select="document(concat($input.dir,'/gml/',$gml.filename))/geo:GeoInformatieObjectVaststelling" xpath-default-namespace=""/>
      <xsl:element name="locatie">
        <xsl:element name="noemer">
          <xsl:value-of select="$id"/>
        </xsl:element>
        <xsl:element name="bestandsnaam">
          <xsl:value-of select="$gml.filename"/>
        </xsl:element>
        <xsl:element name="FRBRExpression">
          <xsl:value-of select="$gml.file//geo:FRBRExpression"/>
        </xsl:element>
        <xsl:for-each select="$gml.file//basisgeo:id">
          <xsl:element name="guid">
            <xsl:value-of select="."/>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:for-each>
  </xsl:param>

  <!-- locaties bevat de opgeschoonde locaties -->
  <xsl:param name="locaties">
    <xsl:for-each-group select="$temp_locaties/locatie" group-by="./noemer">
      <!-- hier controle regelteksten, activiteiten, gebiedsaanwijzingen enz -->
      <xsl:if test="($regelteksten/regeltekst[locatie=current-group()[1]/noemer],$activiteiten/activiteit[locatie=current-group()[1]/noemer],$normen/norm[locatie=current-group()[1]/noemer],$gebiedsaanwijzingen/gebiedsaanwijzing[locatie=current-group()[1]/noemer])">
        <xsl:copy-of select="current-group()[1]"/>
      </xsl:if>
    </xsl:for-each-group>
  </xsl:param>

  <!-- bouw ow-bestanden op -->

  <xsl:template match="/">
    <xsl:call-template name="owRegeltekst"/>
    <xsl:call-template name="owActiviteit"/>
    <xsl:call-template name="owOmgevingsnorm"/>
    <xsl:call-template name="owGebiedsaanwijzing"/>
    <xsl:call-template name="owLocatie"/>
    <xsl:call-template name="owRegelingsgebied"/>
    <xsl:call-template name="opLocatie"/>
  </xsl:template>

  <xsl:template name="owRegeltekst">
    <xsl:if test="$regelteksten/regeltekst">
      <xsl:result-document href="{concat($temp.dir,'/ow/owRegeltekst.xml')}" method="xml">
        <xsl:element name="ow-dc:owBestand">
          <xsl:copy-of select="root()/ow-dc:owBestand/(@*|namespace::*)"/>
          <xsl:element name="sl:standBestand">
            <xsl:element name="sl:dataset">
              <xsl:value-of select="$ID02"/>
            </xsl:element>
            <xsl:element name="sl:inhoud">
              <xsl:element name="sl:gebied">
                <xsl:value-of select="$OIN/lijst/item[BG=$ID01]/naam"/>
              </xsl:element>
              <xsl:element name="sl:leveringsId">
                <xsl:value-of select="fn:string-join(($ID02,fn:format-date(current-date(),'[Y0000][M00][D00]')),'-')"/>
              </xsl:element>
              <xsl:element name="sl:objectTypen">
                <xsl:element name="sl:objectType">
                  <xsl:value-of select="string('Regeltekst')"/>
                </xsl:element>
                <xsl:element name="sl:objectType">
                  <xsl:value-of select="string('RegelVoorIedereen')"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
            <xsl:for-each select="$regelteksten/regeltekst">
              <xsl:variable name="node" select="."/>
              <xsl:variable name="index_regeltekst" select="position()"/>
              <xsl:element name="sl:stand">
                <xsl:element name="ow-dc:owObject">
                  <xsl:element name="r:Regeltekst">
                    <xsl:attribute name="wId" select="@wId"/>
                    <xsl:element name="r:identificatie">
                      <xsl:value-of select="concat('nl.imow-',$ID03,'.regeltekst.',fn:format-date(current-date(),'[Y0000]'),fn:format-number($index_regeltekst,'0000'))"/>
                    </xsl:element>
                  </xsl:element>
                </xsl:element>
              </xsl:element>
              <xsl:element name="sl:stand">
                <xsl:element name="ow-dc:owObject">
                  <xsl:element name="{concat('r:',$node/type)}">
                    <xsl:element name="r:identificatie">
                      <xsl:value-of select="concat('nl.imow-',$ID03,'.juridischeregel.',fn:format-date(current-date(),'[Y0000]'),fn:format-number($index_regeltekst,'0000'))"/>
                    </xsl:element>
                    <xsl:element name="r:idealisatie">
                      <xsl:value-of select="$waardelijsten/waardelijst[titel='Idealisatie']/waarden/waarde[label=($node/idealisatie,'exact')[1]]/uri"/>
                    </xsl:element>
                    <xsl:element name="r:artikelOfLid">
                      <xsl:element name="r:RegeltekstRef">
                        <xsl:attribute name="xlink:href" select="concat('nl.imow-',$ID03,'.regeltekst.',fn:format-date(current-date(),'[Y0000]'),fn:format-number($index_regeltekst,'0000'))"/>
                      </xsl:element>
                    </xsl:element>
                    <xsl:for-each select="$node/thema">
                      <!-- controle uitbreiden met term en alles lower-case -->
                      <xsl:variable name="uri" select="($waardelijsten/waardelijst[titel='Thema']/waarden/waarde[(label=string(current())) or (lower-case(term)=string(current()))]/uri,'http://standaarden.omgevingswet.overheid.nl/onbekend')[1]"/>
                      <xsl:if test="fn:ends-with($uri,'onbekend')">
                        <xsl:comment><xsl:value-of select="concat('Let op: thema ''',string(current()),''' is niet gevonden in waardelijst ''Thema''.')"/></xsl:comment>
                      </xsl:if>
                      <xsl:element name="r:thema">
                        <xsl:value-of select="$uri"/>
                      </xsl:element>
                    </xsl:for-each>
                    <xsl:if test="$node/locatie">
                      <xsl:element name="r:locatieaanduiding">
                        <xsl:for-each select="$node/locatie">
                          <xsl:variable name="index_locatie" select="fn:index-of($locaties/locatie/noemer,.)"/>
                          <xsl:choose>
                            <xsl:when test="$index_locatie gt 0">
                              <xsl:element name="l:LocatieRef">
                                <xsl:attribute name="xlink:href" select="concat('nl.imow-',$ID03,'.gebiedengroep.',fn:format-date(current-date(),'[Y0000]'),fn:format-number($index_locatie,'0000'))"/>
                              </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:comment><xsl:value-of select="concat('Let op: locatie ''',string(current()),''' ontbreekt in owLocatie.xml.')"/></xsl:comment>
                              <xsl:element name="l:LocatieRef">
                                <xsl:attribute name="xlink:href" select="string('onbekend')"/>
                              </xsl:element>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:for-each>
                      </xsl:element>
                    </xsl:if>
                    <xsl:if test="$node/gebiedsaanwijzing">
                      <xsl:element name="r:gebiedsaanwijzing">
                        <xsl:for-each select="$node/gebiedsaanwijzing">
                          <xsl:variable name="gebiedsaanwijzing" select="$gebiedsaanwijzingen/gebiedsaanwijzing[./id=string(current())]"/>
                          <xsl:variable name="index_gebiedsaanwijzing" select="position()"/>
                          <xsl:choose>
                            <xsl:when test="$index_gebiedsaanwijzing gt 0">
                              <xsl:element name="ga:GebiedsaanwijzingRef">
                                <xsl:attribute name="xlink:href" select="concat('nl.imow-',$ID03,'.gebiedsaanwijzing.',fn:format-date(current-date(),'[Y0000]'),fn:format-number($index_gebiedsaanwijzing,'0000'))"/>
                              </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:comment><xsl:value-of select="concat('Let op: gebiedsaanwijzing ''',.,''' ontbreekt in owGebiedsaanwijzing.xml.')"/></xsl:comment>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:for-each>
                      </xsl:element>
                    </xsl:if>
                    <xsl:for-each select="$node/activiteit">
                      <xsl:variable name="activiteit" select="$activiteiten/activiteit[./id=string(current())]"/>
                      <xsl:variable name="index_activiteitaanduiding" select="count($regelteksten/regeltekst[$index_regeltekst]/preceding::activiteit)+position()"/>
                      <xsl:variable name="index_activiteit" select="fn:index-of($activiteiten/activiteit/id,.)"/>
                      <xsl:choose>
                        <xsl:when test="$index_activiteit gt 0">
                          <xsl:element name="r:activiteitaanduiding">
                            <xsl:element name="rol:ActiviteitRef">
                              <xsl:attribute name="xlink:href" select="concat('nl.imow-',$ID03,'.activiteit.',$activiteit/id)"/>
                            </xsl:element>
                            <xsl:element name="r:ActiviteitLocatieaanduiding">
                              <xsl:element name="r:identificatie">
                                <xsl:value-of select="concat('nl.imow-',$ID03,'.activiteitlocatieaanduiding.',fn:format-date(current-date(),'[Y0000]'),fn:format-number($index_activiteitaanduiding,'0000'))"/>
                              </xsl:element>
                              <xsl:choose>
                                <xsl:when test="$node/activiteitregelkwalificatie">
                                  <xsl:variable name="uri" select="($waardelijsten/waardelijst[titel='Activiteitregelkwalificatie']/waarden/waarde[(label=$node/activiteitregelkwalificatie) or (lower-case(term)=$node/activiteitregelkwalificatie)]/uri,'onbekend')[1]"/>
                                  <xsl:if test="$uri='onbekend'">
                                    <xsl:comment><xsl:value-of select="concat('Let op: activiteitregelkwalificatie ''',$node/activiteitregelkwalificatie,''' is niet gevonden in waardelijst ''Activiteitregelkwalificatie''.')"/></xsl:comment>
                                  </xsl:if>
                                  <xsl:element name="r:activiteitregelkwalificatie">
                                    <xsl:value-of select="$uri"/>
                                  </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:comment><xsl:value-of select="string('Let op: de activiteitregelkwalificatie is onbekend.')"/></xsl:comment>
                                  <xsl:element name="r:activiteitregelkwalificatie">
                                    <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/onbekend')"/>
                                  </xsl:element>
                                </xsl:otherwise>
                              </xsl:choose>
                              <xsl:if test="$activiteit/locatie">
                                <xsl:element name="r:locatieaanduiding">
                                  <xsl:for-each select="$activiteit/locatie">
                                    <xsl:variable name="index_locatie" select="fn:index-of($locaties/locatie/noemer,.)"/>
                                    <xsl:choose>
                                      <xsl:when test="$index_locatie gt 0">
                                        <xsl:element name="l:LocatieRef">
                                          <xsl:attribute name="xlink:href" select="concat('nl.imow-',$ID03,'.gebiedengroep.',fn:format-date(current-date(),'[Y0000]'),fn:format-number($index_locatie,'0000'))"/>
                                        </xsl:element>
                                      </xsl:when>
                                      <xsl:otherwise>
                                        <xsl:comment><xsl:value-of select="concat('Let op: locatie ''',string(current()),''' ontbreekt in owLocatie.xml.')"/></xsl:comment>
                                        <xsl:element name="l:LocatieRef">
                                          <xsl:attribute name="xlink:href" select="string('onbekend')"/>
                                        </xsl:element>
                                      </xsl:otherwise>
                                    </xsl:choose>
                                  </xsl:for-each>
                                </xsl:element>
                              </xsl:if>
                            </xsl:element>
                          </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:comment><xsl:value-of select="concat('Let op: activiteit ''',.,''' ontbreekt in owActiviteit.xml.')"/></xsl:comment>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                    <xsl:if test="$node/norm">
                      <xsl:element name="r:omgevingsnormaanduiding">
                        <xsl:for-each select="$node/norm">
                          <xsl:variable name="norm" select="$normen/norm[./id=string(current())]"/>
                          <xsl:variable name="index_norm" select="position()"/>
                          <xsl:choose>
                            <xsl:when test="$index_norm gt 0">
                              <xsl:element name="rol:OmgevingsnormRef">
                                <xsl:attribute name="xlink:href" select="concat('nl.imow-',$ID03,'.omgevingsnorm.',fn:format-date(current-date(),'[Y0000]'),fn:format-number($index_norm,'0000'))"/>
                              </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:comment><xsl:value-of select="concat('Let op: norm ''',.,''' ontbreekt in owOmgevingsnorm.xml.')"/></xsl:comment>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:for-each>
                      </xsl:element>
                    </xsl:if>
                  </xsl:element>
                </xsl:element>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <xsl:template name="owActiviteit">
    <xsl:if test="$activiteiten/activiteit">
      <xsl:result-document href="{concat($temp.dir,'/ow/owActiviteit.xml')}" method="xml">
        <xsl:element name="ow-dc:owBestand">
          <xsl:copy-of select="root()/ow-dc:owBestand/(@*|namespace::*)"/>
          <xsl:element name="sl:standBestand">
            <xsl:element name="sl:dataset">
              <xsl:value-of select="$ID02"/>
            </xsl:element>
            <xsl:element name="sl:inhoud">
              <xsl:element name="sl:gebied">
                <xsl:value-of select="$OIN/lijst/item[BG=$ID01]/naam"/>
              </xsl:element>
              <xsl:element name="sl:leveringsId">
                <xsl:value-of select="fn:string-join(($ID02,fn:format-date(current-date(),'[Y0000][M00][D00]')),'-')"/>
              </xsl:element>
              <xsl:element name="sl:objectTypen">
                <xsl:element name="sl:objectType">
                  <xsl:value-of select="string('Activiteit')"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
            <xsl:for-each select="$activiteiten/activiteit">
              <xsl:variable name="node" select="."/>
              <xsl:variable name="index_activiteit" select="position()"/>
              <xsl:element name="sl:stand">
                <xsl:element name="ow-dc:owObject">
                  <xsl:element name="rol:Activiteit">
                    <xsl:element name="rol:identificatie">
                      <xsl:value-of select="concat('nl.imow-',$ID03,'.activiteit.',($node/id,'onbekend')[1])"/>
                    </xsl:element>
                    <xsl:element name="rol:naam">
                      <xsl:value-of select="($node/naam,'onbekend')[1]"/>
                    </xsl:element>
                    <xsl:choose>
                      <xsl:when test="$node/groep">
                        <xsl:variable name="uri" select="($waardelijsten/waardelijst[titel='Activiteitengroep']/waarden/waarde[(label=$node/groep) or (lower-case(term)=$node/groep)]/uri,'http://standaarden.omgevingswet.overheid.nl/activiteit/id/concept/onbekend')[1]"/>
                        <xsl:if test="fn:ends-with($uri,'onbekend')">
                          <xsl:comment><xsl:value-of select="concat('Let op: activiteitengroep ''',$node/groep,''' is niet gevonden in waardelijst ''Activiteitengroep''.')"/></xsl:comment>
                        </xsl:if>
                        <xsl:element name="rol:groep">
                          <xsl:value-of select="$uri"/>
                        </xsl:element>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:comment><xsl:value-of select="string('Let op: de activiteitengroep is onbekend.')"/></xsl:comment>
                        <xsl:element name="rol:groep">
                          <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/onbekend')"/>
                        </xsl:element>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="$node/gerelateerde_activiteit">
                      <xsl:element name="rol:gerelateerdeActiviteit">
                        <xsl:element name="rol:ActiviteitRef">
                          <xsl:attribute name="xlink:href" select="concat('nl.imow-',$ID03,'.activiteit.',$node/gerelateerde_activiteit)"/>
                        </xsl:element>
                      </xsl:element>
                    </xsl:if>
                    <xsl:choose>
                      <xsl:when test="$node/bovenliggende_activiteit">
                        <xsl:element name="rol:bovenliggendeActiviteit">
                          <xsl:element name="rol:ActiviteitRef">
                            <xsl:attribute name="xlink:href" select="if ($node/bovenliggende_activiteit='onbekend') then string('nl.imow-mnre1034.activiteit.Omgevingsplanactiviteit') else concat('nl.imow-',$ID03,'.activiteit.',$node/bovenliggende_activiteit)"/>
                          </xsl:element>
                        </xsl:element>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:comment><xsl:value-of select="string('Let op: de bovenliggende activiteit is onbekend.')"/></xsl:comment>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:element>
                </xsl:element>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <xsl:template name="owOmgevingsnorm">
    <xsl:if test="$normen/norm">
      <xsl:result-document href="{concat($temp.dir,'/ow/owOmgevingsnorm.xml')}" method="xml">
        <xsl:element name="ow-dc:owBestand">
          <xsl:copy-of select="root()/ow-dc:owBestand/(@*|namespace::*)"/>
          <xsl:element name="sl:standBestand">
            <xsl:element name="sl:dataset">
              <xsl:value-of select="$ID02"/>
            </xsl:element>
            <xsl:element name="sl:inhoud">
              <xsl:element name="sl:gebied">
                <xsl:value-of select="$OIN/lijst/item[BG=$ID01]/naam"/>
              </xsl:element>
              <xsl:element name="sl:leveringsId">
                <xsl:value-of select="fn:string-join(($ID02,fn:format-date(current-date(),'[Y0000][M00][D00]')),'-')"/>
              </xsl:element>
              <xsl:element name="sl:objectTypen">
                <xsl:element name="sl:objectType">
                  <xsl:value-of select="string('Omgevingsnorm')"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
            <xsl:for-each-group select="$normen/norm" group-by="./id">
              <xsl:variable name="index_norm" select="position()"/>
              <xsl:element name="sl:stand">
                <xsl:element name="ow-dc:owObject">
                  <xsl:element name="rol:Omgevingsnorm">
                    <xsl:element name="rol:identificatie">
                      <xsl:value-of select="concat('nl.imow-',$ID03,'.omgevingsnorm.',fn:format-date(current-date(),'[Y0000]'),fn:format-number($index_norm,'0000'))"/>
                    </xsl:element>
                    <xsl:element name="rol:naam">
                      <xsl:value-of select="(current-group()[1]/naam,'onbekend')[1]"/>
                    </xsl:element>
                    <xsl:choose>
                      <xsl:when test="current-group()[1]/type">
                        <xsl:variable name="uri" select="($waardelijsten/waardelijst[titel='TypeNorm']/waarden/waarde[(lower-case(term)=current-group()[1]/type) or (label=current-group()[1]/type)]/uri,'http://standaarden.omgevingswet.overheid.nl/onbekend')[1]"/>
                        <xsl:if test="fn:ends-with($uri,'onbekend')">
                          <xsl:comment><xsl:value-of select="concat('Let op: type norm ''',current-group()[1]/type,''' is niet gevonden in waardelijst ''TypeNorm''.')"/></xsl:comment>
                        </xsl:if>
                        <xsl:element name="rol:type">
                          <xsl:value-of select="$uri"/>
                        </xsl:element>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:comment><xsl:value-of select="string('Let op: type norm en naam norm zijn onbekend.')"/></xsl:comment>
                        <xsl:element name="rol:type">
                          <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/onbekend')"/>
                        </xsl:element>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="current-group()[1]/eenheid">
                      <xsl:variable name="uri" select="($waardelijsten/waardelijst[titel='Eenheid']/waarden/waarde[label=current-group()[1]/eenheid]/uri,'http://standaarden.omgevingswet.overheid.nl/onbekend')[1]"/>
                      <xsl:if test="fn:ends-with($uri,'onbekend')">
                        <xsl:comment><xsl:value-of select="concat('Let op: eenheid ''',current-group()[1]/eenheid,''' is niet gevonden in waardelijst ''Eenheid''.')"/></xsl:comment>
                      </xsl:if>
                      <xsl:element name="rol:eenheid">
                        <xsl:value-of select="$uri"/>
                      </xsl:element>
                    </xsl:if>
                    <xsl:if test="current-group()/waarde">
                      <xsl:element name="rol:normwaarde">
                        <xsl:for-each select="current-group()">
                          <xsl:variable name="node" select="."/>
                          <xsl:variable name="index_waarde" select="position()"/>
                          <xsl:element name="rol:Normwaarde">
                            <xsl:element name="rol:identificatie">
                              <xsl:value-of select="concat('nl.imow-',$ID03,'.normwaarde.',fn:format-date(current-date(),'[Y0000]'),fn:format-number($index_norm,'0000'),fn:format-number($index_waarde,'0000'))"/>
                            </xsl:element>
                            <xsl:choose>
                              <xsl:when test="contains($node/waarde,'regeltekst')">
                                <xsl:element name="rol:waardeInRegeltekst">
                                  <xsl:value-of select="$node/waarde"/>
                                </xsl:element>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:element name="rol:kwantitatieveWaarde">
                                  <xsl:value-of select="$node/waarde"/>
                                </xsl:element>
                              </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="$node/locatie">
                              <xsl:element name="rol:locatieaanduiding">
                                <xsl:for-each select="$node/locatie">
                                  <xsl:variable name="index_locatie" select="fn:index-of($locaties/locatie/noemer,.)"/>
                                  <xsl:choose>
                                    <xsl:when test="$index_locatie gt 0">
                                      <xsl:element name="l:LocatieRef">
                                        <xsl:attribute name="xlink:href" select="concat('nl.imow-',$ID03,'.gebiedengroep.',fn:format-date(current-date(),'[Y0000]'),fn:format-number($index_locatie,'0000'))"/>
                                      </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:comment><xsl:value-of select="concat('Let op: locatie ''',string(current()),''' ontbreekt in owLocatie.xml.')"/></xsl:comment>
                                      <xsl:element name="l:LocatieRef">
                                        <xsl:attribute name="xlink:href" select="string('onbekend')"/>
                                      </xsl:element>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </xsl:for-each>
                              </xsl:element>
                            </xsl:if>
                          </xsl:element>
                        </xsl:for-each>
                      </xsl:element>
                    </xsl:if>
                    <xsl:choose>
                      <xsl:when test="current-group()[1]/groep">
                        <xsl:variable name="uri" select="($waardelijsten/waardelijst[titel='Omgevingsnormgroep']/waarden/waarde[(label=current-group()[1]/groep) or (lower-case(term)=current-group()[1]/groep)]/uri,'http://standaarden.omgevingswet.overheid.nl/onbekend')[1]"/>
                        <xsl:if test="fn:ends-with($uri,'onbekend')">
                          <xsl:comment><xsl:value-of select="concat('Let op: omgevingsnormgroep ''',current-group()[1]/groep,''' is niet gevonden in waardelijst ''Omgevingsnormgroep''.')"/></xsl:comment>
                        </xsl:if>
                        <xsl:element name="rol:groep">
                          <xsl:value-of select="$uri"/>
                        </xsl:element>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:comment><xsl:value-of select="string('Let op: de omgevingsnormgroep is onbekend.')"/></xsl:comment>
                        <xsl:element name="rol:groep">
                          <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/onbekend')"/>
                        </xsl:element>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:element>
                </xsl:element>
              </xsl:element>
            </xsl:for-each-group>
          </xsl:element>
        </xsl:element>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <xsl:template name="owGebiedsaanwijzing">
    <xsl:if test="$gebiedsaanwijzingen/gebiedsaanwijzing">
      <xsl:result-document href="{concat($temp.dir,'/ow/owGebiedsaanwijzing.xml')}" method="xml">
        <xsl:element name="ow-dc:owBestand">
          <xsl:copy-of select="root()/ow-dc:owBestand/(@*|namespace::*)"/>
          <xsl:element name="sl:standBestand">
            <xsl:element name="sl:dataset">
              <xsl:value-of select="$ID02"/>
            </xsl:element>
            <xsl:element name="sl:inhoud">
              <xsl:element name="sl:gebied">
                <xsl:value-of select="$OIN/lijst/item[BG=$ID01]/naam"/>
              </xsl:element>
              <xsl:element name="sl:leveringsId">
                <xsl:value-of select="fn:string-join(($ID02,fn:format-date(current-date(),'[Y0000][M00][D00]')),'-')"/>
              </xsl:element>
              <xsl:element name="sl:objectTypen">
                <xsl:element name="sl:objectType">
                  <xsl:value-of select="string('Gebiedsaanwijzing')"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
            <xsl:for-each select="$gebiedsaanwijzingen/gebiedsaanwijzing">
              <xsl:variable name="node" select="."/>
              <xsl:variable name="index_gebiedsaanwijzing" select="position()"/>
              <xsl:element name="sl:stand">
                <xsl:element name="ow-dc:owObject">
                  <xsl:element name="ga:Gebiedsaanwijzing">
                    <xsl:element name="ga:identificatie">
                      <xsl:value-of select="concat('nl.imow-',$ID03,'.gebiedsaanwijzing.',fn:format-date(current-date(),'[Y0000]'),fn:format-number($index_gebiedsaanwijzing,'0000'))"/>
                    </xsl:element>
                    <xsl:choose>
                      <xsl:when test="$node/type">
                        <xsl:variable name="uri" select="($waardelijsten/waardelijst[titel='TypeGebiedsaanwijzing']/waarden/waarde[term=$node/type]/uri,'http://standaarden.omgevingswet.overheid.nl/onbekend')[1]"/>
                        <xsl:if test="fn:ends-with($uri,'onbekend')">
                          <xsl:comment><xsl:value-of select="concat('Let op: type gebiedsaanwijzing ''',$node/type,''' is niet gevonden in waardelijst ''TypeGebiedsaanwijzing''.')"/></xsl:comment>
                        </xsl:if>
                        <xsl:element name="ga:type">
                          <xsl:value-of select="$uri"/>
                        </xsl:element>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:comment><xsl:value-of select="string('Let op: type gebiedsaanwijzing is onbekend.')"/></xsl:comment>
                        <xsl:element name="ga:type">
                          <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/onbekend')"/>
                        </xsl:element>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:element name="ga:naam">
                      <xsl:value-of select="($node/naam,'onbekend')[1]"/>
                    </xsl:element>
                    <xsl:choose>
                      <xsl:when test="$node/groep">
                        <xsl:variable name="uri" select="($waardelijsten/waardelijst[titel=concat($node/type,'groep')]/waarden/waarde[(label=$node/groep) or (lower-case(term)=$node/groep)]/uri,'http://standaarden.omgevingswet.overheid.nl/onbekend')[1]"/>
                        <xsl:if test="fn:ends-with($uri,'onbekend')">
                          <xsl:comment><xsl:value-of select="concat('Let op: groep ''',$node/groep,''' is niet gevonden in waardelijst ''',concat($node/type,'groep'),'''.')"/></xsl:comment>
                        </xsl:if>
                        <xsl:element name="ga:groep">
                          <xsl:value-of select="$uri"/>
                        </xsl:element>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:comment><xsl:value-of select="string('Let op: de groep is onbekend.')"/></xsl:comment>
                        <xsl:element name="ga:groep">
                          <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/onbekend')"/>
                        </xsl:element>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="$node/locatie">
                      <xsl:element name="ga:locatieaanduiding">
                        <xsl:for-each select="$node/locatie">
                          <xsl:variable name="index_locatie" select="fn:index-of($locaties/locatie/noemer,.)"/>
                          <xsl:choose>
                            <xsl:when test="$index_locatie gt 0">
                              <xsl:element name="l:LocatieRef">
                                <xsl:attribute name="xlink:href" select="concat('nl.imow-',$ID03,'.gebiedengroep.',fn:format-date(current-date(),'[Y0000]'),fn:format-number($index_locatie,'0000'))"/>
                              </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:comment><xsl:value-of select="concat('Let op: locatie ''',string(current()),''' ontbreekt in owLocatie.xml.')"/></xsl:comment>
                              <xsl:element name="l:LocatieRef">
                                <xsl:attribute name="xlink:href" select="string('onbekend')"/>
                              </xsl:element>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:for-each>
                      </xsl:element>
                    </xsl:if>
                  </xsl:element>
                </xsl:element>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <xsl:template name="owLocatie">
    <xsl:if test="$locaties/locatie">
      <xsl:result-document href="{concat($temp.dir,'/ow/owLocatie.xml')}" method="xml">
        <xsl:element name="ow-dc:owBestand">
          <xsl:copy-of select="root()/ow-dc:owBestand/(@*|namespace::*)"/>
          <xsl:element name="sl:standBestand">
            <xsl:element name="sl:dataset">
              <xsl:value-of select="$ID02"/>
            </xsl:element>
            <xsl:element name="sl:inhoud">
              <xsl:element name="sl:gebied">
                <xsl:value-of select="$OIN/lijst/item[BG=$ID01]/naam"/>
              </xsl:element>
              <xsl:element name="sl:leveringsId">
                <xsl:value-of select="fn:string-join(($ID02,fn:format-date(current-date(),'[Y0000][M00][D00]')),'-')"/>
              </xsl:element>
              <xsl:element name="sl:objectTypen">
                <xsl:element name="sl:objectType">
                  <xsl:value-of select="string('Gebiedengroep')"/>
                </xsl:element>
                <xsl:element name="sl:objectType">
                  <xsl:value-of select="string('Gebied')"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
            <xsl:for-each select="$locaties/locatie">
              <xsl:variable name="node" select="."/>
              <xsl:variable name="index_locatie" select="position()"/>
              <xsl:element name="sl:stand">
                <xsl:element name="ow-dc:owObject">
                  <xsl:element name="l:Gebiedengroep">
                    <xsl:element name="l:identificatie">
                      <xsl:value-of select="concat('nl.imow-',$ID03,'.gebiedengroep.',fn:format-date(current-date(),'[Y0000]'),fn:format-number($index_locatie,'0000'))"/>
                    </xsl:element>
                    <xsl:element name="l:noemer">
                      <xsl:value-of select="($node/noemer,'onbekend')[1]"/>
                    </xsl:element>
                    <xsl:choose>
                      <xsl:when test="$node/guid">
                        <xsl:element name="l:groepselement">
                          <xsl:for-each select="$node/guid">
                            <xsl:element name="l:GebiedRef">
                              <xsl:attribute name="xlink:href" select="concat('nl.imow-',$ID03,'.gebied.',fn:format-date(current-date(),'[Y0000]'),fn:format-number($index_locatie,'0000'),fn:format-number(position(),'0000'))"/>
                            </xsl:element>
                          </xsl:for-each>
                        </xsl:element>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:comment><xsl:value-of select="string('Let op: voor deze gebiedengroep is geen gml beschikbaar.')"/></xsl:comment>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:element>
                </xsl:element>
              </xsl:element>
              <xsl:for-each select="$node/guid">
                <xsl:element name="sl:stand">
                  <xsl:element name="ow-dc:owObject">
                    <xsl:element name="l:Gebied">
                      <xsl:element name="l:identificatie">
                        <xsl:value-of select="concat('nl.imow-',$ID03,'.gebied.',fn:format-date(current-date(),'[Y0000]'),fn:format-number($index_locatie,'0000'),fn:format-number(position(),'0000'))"/>
                      </xsl:element>
                      <xsl:element name="l:geometrie">
                        <xsl:element name="l:GeometrieRef">
                          <xsl:attribute name="xlink:href" select="."/>
                        </xsl:element>
                      </xsl:element>
                    </xsl:element>
                  </xsl:element>
                </xsl:element>
              </xsl:for-each>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <xsl:template name="owRegelingsgebied">
    <xsl:variable name="node" select="$locaties/locatie[noemer='ambtsgebied'][1]"/>
    <xsl:variable name="index_locatie" select="fn:index-of($locaties/locatie/noemer,'ambtsgebied')"/>
    <xsl:if test="$node">
      <xsl:result-document href="{concat($temp.dir,'/ow/owRegelingsgebied.xml')}" method="xml">
        <xsl:element name="ow-dc:owBestand">
          <xsl:copy-of select="root()/ow-dc:owBestand/(@*|namespace::*)"/>
          <xsl:element name="sl:standBestand">
            <xsl:element name="sl:dataset">
              <xsl:value-of select="$ID02"/>
            </xsl:element>
            <xsl:element name="sl:inhoud">
              <xsl:element name="sl:gebied">
                <xsl:value-of select="$OIN/lijst/item[BG=$ID01]/naam"/>
              </xsl:element>
              <xsl:element name="sl:leveringsId">
                <xsl:value-of select="fn:string-join(($ID02,fn:format-date(current-date(),'[Y0000][M00][D00]')),'-')"/>
              </xsl:element>
              <xsl:element name="sl:objectTypen">
                <xsl:element name="sl:objectType">
                  <xsl:value-of select="string('Regelingsgebied')"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
            <xsl:element name="sl:stand">
              <xsl:element name="ow-dc:owObject">
                <xsl:element name="rg:Regelingsgebied">
                  <xsl:element name="rg:identificatie">
                    <xsl:value-of select="concat('nl.imow-',$ID03,'.regelingsgebied.',fn:format-date(current-date(),'[Y0000]'),'0001')"/>
                  </xsl:element>
                  <xsl:element name="rg:locatieaanduiding">
                    <xsl:element name="l:LocatieRef">
                      <xsl:attribute name="xlink:href" select="concat('nl.imow-',$ID03,'.gebiedengroep.',fn:format-date(current-date(),'[Y0000]'),fn:format-number($index_locatie,'0000'))"/>
                    </xsl:element>
                  </xsl:element>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <!-- maak een tijdelijk bestand van alle gebiedengroepen -->

  <xsl:template name="opLocatie">
    <xsl:if test="$locaties/locatie">
      <xsl:result-document href="{concat($temp.dir,'/locaties.xml')}" method="xml">
        <xsl:element name="locaties">
          <xsl:for-each select="$locaties/locatie">
            <xsl:variable name="node" select="."/>
            <xsl:variable name="index" select="position()"/>
            <xsl:element name="locatie">
              <xsl:element name="id">
                <xsl:value-of select="concat('nl.imow-',$ID03,'.gebiedengroep.',fn:format-date(current-date(),'[Y0000]'),fn:format-number($index,'0000'))"/>
              </xsl:element>
              <xsl:element name="noemer">
                <xsl:value-of select="($node/noemer,'onbekend')[1]"/>
              </xsl:element>
              <xsl:element name="bestandsnaam">
                <xsl:value-of select="($node/bestandsnaam,'onbekend')[1]"/>
              </xsl:element>
              <xsl:element name="FRBRExpression">
                <xsl:value-of select="($node/FRBRExpression,'onbekend')[1]"/>
              </xsl:element>
              <xsl:element name="guid">
                <xsl:value-of select="(fn:string-join($node/guid,', '),'onbekend')[1]"/>
              </xsl:element>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <!-- routines -->

  <xsl:template name="check_row">
    <xsl:param name="current"/>
    <xsl:for-each-group select="Cell" group-starting-with="Cell[@ss:Index]" xpath-default-namespace="urn:schemas-microsoft-com:office:spreadsheet">
      <xsl:variable name="index" select="number((current-group()[1]/@ss:Index,'1')[1])"/>
      <xsl:for-each select="current-group()">
        <xsl:variable name="positie" select="position()-1"/>
        <xsl:element name="cell">
          <xsl:attribute name="index" select="$index+$positie"/>
          <xsl:for-each select="Data" xpath-default-namespace="urn:schemas-microsoft-com:office:spreadsheet">
            <xsl:element name="data">
              <xsl:value-of select="."/>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:for-each>
    </xsl:for-each-group>
  </xsl:template>

</xsl:stylesheet>