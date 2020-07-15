<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:da="http://www.geostandaarden.nl/imow/datatypenalgemeen/v20190709" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing/v20190709" xmlns:k="http://www.geostandaarden.nl/imow/kaartrecept/v20190901" xmlns:l="http://www.geostandaarden.nl/imow/locatie/v20190901" xmlns:ow="http://www.geostandaarden.nl/imow/owobject" xmlns:p="http://www.geostandaarden.nl/imow/pons/v20190901" xmlns:r="http://www.geostandaarden.nl/imow/regels/v20190901" xmlns:rkow="http://www.geostandaarden.nl/imow/owobject/v20190709" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie/v20190901" xmlns:rol-ref="http://www.geostandaarden.nl/imow/regelsoplocatie-ref/v20190709" xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek/v20190301" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst/v20190901" xmlns:vt-ref="http://www.geostandaarden.nl/imow/vrijetekst-ref/v20190901" version="2.0">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
  <xsl:strip-space elements="*"/>

  <xsl:param name="file.config" select="replace(document-uri(),'template','config')"/>

  <!-- doorgegeven parameters -->

  <xsl:param name="file.list" select="string('C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-aardkundige_waarden.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-agrarische_cultuurlandschappen.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-archeologisch_waardevolle_zones.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-beperken_bodembewerking.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-beschermingszone_drinkwaterwinning.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-bodemdaling_landelijk_gebied.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-bodemdaling_stedelijk_gebied.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-bovenlokaal_dagrecreatieterrein.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-eemland.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-experimenteerruimte.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-gelderse_vallei.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-geluidscontour_61_db_lden.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-gezonde_en_veilige_leefomgeving.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-groene_hart.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-grondwaterlichamen.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-historische_buitenplaatszones.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-historische_infrastructuur.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-hollandse_waterlinies.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-kernrandzone.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-militair_erfgoed.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-neder-germaanse_limes.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-overstroombaar_gebied.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-recreatietoervaartnet.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-recreatiewoningen.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-recreatiezone.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-regionale_kering.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-rivierengebied.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-stelling_van_amsterdam.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-stiltegebieden.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-utrechtse_heuvelrug.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-waterbergingsgebied.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-zoekgebied_drinkwater.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/GIO-zwemwater.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/manifest-ow.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/manifest.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/opdracht.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/owGebiedsaanwijzing.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/owHoofdlijn.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/owLocatie.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/owVrijetekst.xml;C:/Users/g.wolbers/Desktop/transformatie/0.98.3-kern/opdracht/resultaat.xml')"/>

  <!-- alle namespaces -->

  <xsl:param name="ns_old" select="('ow-dc','ow','da','sl','ga-ref','ga','g-ref','k','l-ref','l','p','r-ref','r','rol-ref','rol','vt-ref','vt','xlink')"/>
  <xsl:param name="ns_new" select="('ow-dc','ow','da','sl','ga','ga','l','k','l','l','p','r','r','rol','rol','vt','vt','xlink')"/>
  <xsl:param name="uri_old" select="('http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901','http://www.geostandaarden.nl/imow/owobject/v20190709','http://www.geostandaarden.nl/imow/datatypenalgemeen/v20190709','http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek/v20190301','http://www.geostandaarden.nl/imow/gebiedsaanwijzing-ref/v20190709','http://www.geostandaarden.nl/imow/gebiedsaanwijzing/v20190709','http://www.geostandaarden.nl/imow/geometrie-ref/v20190901','http://www.geostandaarden.nl/imow/kaartrecept/v20190901','http://www.geostandaarden.nl/imow/locatie-ref/v20190901','http://www.geostandaarden.nl/imow/locatie/v20190901','http://www.geostandaarden.nl/imow/pons/v20190901','http://www.geostandaarden.nl/imow/regels-ref/v20190901','http://www.geostandaarden.nl/imow/regels/v20190901','http://www.geostandaarden.nl/imow/regelsoplocatie-ref/v20190709','http://www.geostandaarden.nl/imow/regelsoplocatie/v20190901','http://www.geostandaarden.nl/imow/vrijetekst-ref/v20190901','http://www.geostandaarden.nl/imow/vrijetekst/v20190901','http://www.w3.org/1999/xlink')"/>
  <xsl:param name="uri_new" select="('http://www.geostandaarden.nl/imow/bestanden/deelbestand','http://www.geostandaarden.nl/imow/owobject','http://www.geostandaarden.nl/imow/datatypenalgemeen','http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek','http://www.geostandaarden.nl/imow/gebiedsaanwijzing','http://www.geostandaarden.nl/imow/gebiedsaanwijzing','http://www.geostandaarden.nl/imow/locatie','http://www.geostandaarden.nl/imow/kaart','http://www.geostandaarden.nl/imow/locatie','http://www.geostandaarden.nl/imow/locatie','http://www.geostandaarden.nl/imow/pons','http://www.geostandaarden.nl/imow/regels','http://www.geostandaarden.nl/imow/regels','http://www.geostandaarden.nl/imow/regelsoplocatie','http://www.geostandaarden.nl/imow/regelsoplocatie','http://www.geostandaarden.nl/imow/vrijetekst','http://www.geostandaarden.nl/imow/vrijetekst','http://www.w3.org/1999/xlink')"/>

  <xsl:param name="xmlns" select="string('http://www.geostandaarden.nl/bestanden-ow/manifest-ow')"/>

  <!-- waardelijst -->

  <xsl:param name="waardelijsten" select="document('waardelijsten 1.0.3.xml')//waardelijst"/>

  <!-- stel manifest-bestand samen -->

  <xsl:param name="manifest">
    <xsl:for-each select="tokenize($file.list,';')">
      <xsl:choose>
        <xsl:when test="document(concat('file:/',.))//r:Regeltekst" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('regeltekst.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="."/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize(.,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document(concat('file:/',.))//vt:FormeleDivisie" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('vrijetekst.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="."/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize(.,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document(concat('file:/',.))//rol:Activiteit" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('activiteit.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="."/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize(.,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document(concat('file:/',.))//ga:Gebiedsaanwijzing" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('gebiedsaanwijzing.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="."/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize(.,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document(concat('file:/',.))//rol:Normwaarde" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('normwaarde.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="."/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize(.,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document(concat('file:/',.))//l:Gebied" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('locatie.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="."/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize(.,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document(concat('file:/',.))//p:Pons" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('pons.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="."/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize(.,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document(concat('file:/',.))//k:Kaart" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('kaart.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="."/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize(.,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document(concat('file:/',.))//vt:Hoofdlijn" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('kaart.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="."/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize(.,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document(concat('file:/',.))//*:Modules">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('manifest_ow.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="."/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize(.,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:param>

  <!-- transformeer OW-bestanden -->

  <xsl:param name="regeltekst" select="document(concat('file:/',($manifest/file[@name='regeltekst.xml']/fullname,'geen')[1]))"/>
  <xsl:param name="vrijetekst" select="document(concat('file:/',($manifest/file[@name='vrijetekst.xml']/fullname,'geen')[1]))"/>
  <xsl:param name="activiteit" select="document(concat('file:/',($manifest/file[@name='activiteit.xml']/fullname,'geen')[1]))"/>
  <xsl:param name="gebiedsaanwijzing" select="document(concat('file:/',($manifest/file[@name='gebiedsaanwijzing.xml']/fullname,'geen')[1]))"/>
  <xsl:param name="normwaarde" select="document(concat('file:/',($manifest/file[@name='normwaarde.xml']/fullname,'geen')[1]))"/>
  <xsl:param name="locatie" select="document(concat('file:/',($manifest/file[@name='locatie.xml']/fullname,'geen')[1]))"/>
  <xsl:param name="pons" select="document(concat('file:/',($manifest/file[@name='pons.xml']/fullname,'geen')[1]))"/>
  <xsl:param name="kaart" select="document(concat('file:/',($manifest/file[@name='kaart.xml']/fullname,'geen')[1]))"/>
  <xsl:param name="hoofdlijn" select="document(concat('file:/',($manifest/file[@name='hoofdlijn.xml']/fullname,'geen')[1]))"/>
  <xsl:param name="manifest_ow" select="document(concat('file:/',($manifest/file[@name='manifest_ow.xml']/fullname,'geen')[1]))"/>
  <xsl:param name="ID01" select="tokenize(tokenize(($regeltekst//r:Regeltekst/r:identificatie)[1],'-')[2],'\.')[1]"/>
  <xsl:param name="ID02" select="substring(tokenize(tokenize(($regeltekst//r:Regeltekst/r:identificatie)[1],'-')[2],'\.')[3],1,4)"/>

  <xsl:template match="/">
    <xsl:call-template name="manifest"/>
    <xsl:call-template name="regeltekst"/>
    <xsl:call-template name="vrijetekst"/>
    <xsl:call-template name="activiteit"/>
    <xsl:call-template name="gebiedsaanwijzing"/>
    <xsl:call-template name="normwaarde"/>
    <xsl:call-template name="locatie"/>
    <xsl:call-template name="pons"/>
    <xsl:call-template name="kaart"/>
    <xsl:call-template name="hoofdlijn"/>
    <xsl:call-template name="manifest_ow"/>
  </xsl:template>

  <!-- maak manifest-bestand waarin is aangegeven wat de functie van een bestand is -->

  <xsl:template name="manifest">
    <xsl:element name="manifest">
      <xsl:for-each select="$manifest/file">
        <xsl:copy-of select="."/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <!-- transformeer generieke zaken -->

  <xsl:template match="owBestand" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901">
    <xsl:element name="ow-dc:owBestand" namespace="{$uri_new[1]}">
      <xsl:namespace name="{$ns_new[1]}" select="$uri_new[1]"/>
      <xsl:namespace name="{$ns_new[2]}" select="$uri_new[2]"/>
      <xsl:namespace name="{$ns_new[3]}" select="$uri_new[3]"/>
      <xsl:namespace name="{$ns_new[4]}" select="$uri_new[4]"/>
      <xsl:namespace name="{$ns_new[6]}" select="$uri_new[6]"/>
      <xsl:namespace name="{$ns_new[8]}" select="$uri_new[8]"/>
      <xsl:namespace name="{$ns_new[10]}" select="$uri_new[10]"/>
      <xsl:namespace name="{$ns_new[11]}" select="$uri_new[11]"/>
      <xsl:namespace name="{$ns_new[13]}" select="$uri_new[13]"/>
      <xsl:namespace name="{$ns_new[15]}" select="$uri_new[15]"/>
      <xsl:namespace name="{$ns_new[17]}" select="$uri_new[17]"/>
      <xsl:namespace name="{$ns_new[18]}" select="$uri_new[18]"/>
      <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand https://register.geostandaarden.nl/xmlschema/tpod/v1.0.2/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd')"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="sl:objectType">
    <xsl:element name="{name()}" namespace="{$uri_new[4]}">
      <xsl:apply-templates select="@*"/>
      <xsl:value-of select="replace(.,'Formele','')"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@xlink:href">
    <xsl:attribute name="xlink:href" select="replace(.,'formele','')"/>
  </xsl:template>

  <!-- transformeer regeltekst -->

  <xsl:template name="regeltekst">
    <xsl:if test="$regeltekst">
      <xsl:result-document href="regeltekst.xml" method="xml">
        <xsl:apply-templates select="$regeltekst/node()"/>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <xsl:template match="r:RegelVoorIedereen|r:Omgevingswaarderegel|r:Instructieregel">
    <xsl:variable name="ID03" select="count(.|preceding::r:RegelVoorIedereen|preceding::r:Omgevingswaarderegel|preceding::r:Instructieregel)"/>
    <xsl:element name="{name()}" namespace="{$uri_new[13]}">
      <xsl:apply-templates select="@*"/>
      <xsl:element name="r:identificatie" namespace="{$uri_new[13]}">
        <xsl:value-of select="concat('nl.imow-',$ID01,'.juridischeregel.',$ID02,format-number($ID03,'000000'))"/>
      </xsl:element>
      <xsl:apply-templates select="(ow:status,ow:procedurestatus,r:idealisatie,r:artikelOfLid,r:thema,r:locatieaanduiding,r:gebiedsaanwijzing,r:kaartaanduiding,r:activiteitaanduiding,r:instructieregelInstrument,r:instructieregelTaakuitoefening,r:omgevingsnormaanduiding,r:normwaardeaanduiding)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="r:idealisatie">
    <xsl:variable name="waarde" select="$waardelijsten[titel='Idealisatie']/waarden/waarde[lower-case(label)=lower-case(current())]/uri"/>
    <xsl:choose>
      <xsl:when test="$waarde">
        <xsl:element name="{name()}" namespace="{$uri_new[13]}">
          <xsl:value-of select="$waarde"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:comment>
          <xsl:value-of select="concat('Let op: waarde &quot;',current(),'&quot; ontbreekt in waardelijst &quot;Idealisatie&quot;')"/>
        </xsl:comment>
        <xsl:element name="{name()}" namespace="{$uri_new[13]}">
          <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/onbekend')"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="r:thema">
    <xsl:variable name="waarde" select="$waardelijsten[titel='Thema']/waarden/waarde[lower-case(label)=lower-case(current())]/uri"/>
    <xsl:choose>
      <xsl:when test="$waarde">
        <xsl:element name="{name()}" namespace="{$uri_new[13]}">
          <xsl:value-of select="$waarde"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:comment>
          <xsl:value-of select="concat('Let op: waarde &quot;',current(),'&quot; ontbreekt in waardelijst &quot;Thema&quot;')"/>
        </xsl:comment>
        <xsl:element name="{name()}" namespace="{$uri_new[13]}">
          <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/onbekend')"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="r:activiteitaanduiding">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>

  <xsl:template match="r:activiteitaanduiding/rol-ref:ActiviteitRef">
    <xsl:variable name="ID00" select="@xlink:href"/>
    <xsl:variable name="ID03" select="count(.|preceding::rol-ref:ActiviteitRef)"/>
    <xsl:element name="r:activiteitaanduiding" namespace="{$uri_new[13]}">
      <xsl:element name="rol:ActiviteitRef" namespace="{$uri_new[14]}">
        <xsl:attribute name="xlink:href" select="$ID00"/>
      </xsl:element>
      <xsl:element name="r:ActiviteitLocatieaanduiding" namespace="{$uri_new[13]}">
        <xsl:element name="r:identificatie" namespace="{$uri_new[13]}">
          <xsl:value-of select="concat('nl.imow-',$ID01,'.activiteitlocatieaanduiding.',$ID02,format-number($ID03,'000000'))"/>
        </xsl:element>
        <xsl:apply-templates select="(ancestor::r:RegelVoorIedereen|ancestor::r:Omgevingswaarderegel|ancestor::r:Instructieregel)[1]/r:activiteitregelkwalificatie"/>
        <xsl:element name="r:locatieaanduiding" namespace="{$uri_new[13]}">
          <xsl:apply-templates select="$activiteit//rol:Activiteit[rol:identificatie=$ID00]/rol:locatieaanduiding/node()"/>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="r:activiteitregelkwalificatie">
    <xsl:variable name="waarde" select="$waardelijsten[titel='Activiteitregelkwalificatie']/waarden/waarde[lower-case(label)=lower-case(current())]/uri"/>
    <xsl:choose>
      <xsl:when test="$waarde">
        <xsl:element name="{name()}" namespace="{$uri_new[13]}">
          <xsl:value-of select="$waarde"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:comment>
          <xsl:value-of select="concat('Let op: waarde &quot;',current(),'&quot; ontbreekt in waardelijst &quot;Activiteitregelkwalificatie&quot;')"/>
        </xsl:comment>
        <xsl:element name="{name()}" namespace="{$uri_new[13]}">
          <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/onbekend')"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="r:instructieregelInstrument">
    <xsl:variable name="waarde" select="$waardelijsten[titel='Instrument']/waarden/waarde[lower-case(label)=lower-case(current())]/uri"/>
    <xsl:choose>
      <xsl:when test="$waarde">
        <xsl:element name="{name()}" namespace="{$uri_new[13]}">
          <xsl:value-of select="$waarde"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:comment>
          <xsl:value-of select="concat('Let op: waarde &quot;',current(),'&quot; ontbreekt in waardelijst &quot;Instrument&quot;')"/>
        </xsl:comment>
        <xsl:element name="{name()}" namespace="{$uri_new[13]}">
          <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/onbekend')"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="r:instructieregelTaakuitoefening">
    <xsl:variable name="waarde" select="$waardelijsten[titel='Adressaat']/waarden/waarde[lower-case(label)=lower-case(current())]/uri"/>
    <xsl:choose>
      <xsl:when test="$waarde">
        <xsl:element name="{name()}" namespace="{$uri_new[13]}">
          <xsl:value-of select="$waarde"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:comment>
          <xsl:value-of select="concat('Let op: waarde &quot;',current(),'&quot; ontbreekt in waardelijst &quot;Adressaat&quot;')"/>
        </xsl:comment>
        <xsl:element name="{name()}" namespace="{$uri_new[13]}">
          <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/onbekend')"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- transformeer vrijetekst -->

  <xsl:template name="vrijetekst">
    <xsl:if test="$vrijetekst">
      <xsl:result-document href="vrijetekst.xml" method="xml">
        <xsl:apply-templates select="$vrijetekst/node()"/>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <xsl:template match="vt:FormeleDivisie">
    <xsl:element name="vt:Divisie" namespace="{$uri_new[17]}">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="vt:identificatie">
    <xsl:element name="vt:identificatie" namespace="{$uri_new[17]}">
      <xsl:value-of select="replace(.,'formele','')"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="vt:Tekstdeel">
    <xsl:element name="vt:Tekstdeel" namespace="{$uri_new[17]}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="(ow:status,ow:procedurestatus,vt:identificatie,vt:idealisatie,vt:thema,vt:formeleDivisie,vt:hoofdlijnaanduiding,vt:kaartaanduiding,vt:locatieaanduiding,vt:gebiedsaanwijzing)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="vt:idealisatie">
    <xsl:variable name="waarde" select="$waardelijsten[titel='Idealisatie']/waarden/waarde[lower-case(label)=lower-case(current())]/uri"/>
    <xsl:choose>
      <xsl:when test="$waarde">
        <xsl:element name="{name()}" namespace="{$uri_new[17]}">
          <xsl:value-of select="$waarde"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:comment>
          <xsl:value-of select="concat('Let op: waarde &quot;',current(),'&quot; ontbreekt in waardelijst &quot;Idealisatie&quot;')"/>
        </xsl:comment>
        <xsl:element name="{name()}" namespace="{$uri_new[17]}">
          <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/onbekend')"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="vt:thema">
    <xsl:variable name="waarde" select="$waardelijsten[titel='Thema']/waarden/waarde[lower-case(label)=lower-case(current())]/uri"/>
    <xsl:choose>
      <xsl:when test="$waarde">
        <xsl:element name="{name()}" namespace="{$uri_new[17]}">
          <xsl:value-of select="$waarde"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:comment>
          <xsl:value-of select="concat('Let op: waarde &quot;',current(),'&quot; ontbreekt in waardelijst &quot;Thema&quot;')"/>
        </xsl:comment>
        <xsl:element name="{name()}" namespace="{$uri_new[17]}">
          <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/onbekend')"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="vt:formeleDivisie">
    <xsl:element name="vt:divisieaanduiding" namespace="{$uri_new[17]}">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="vt-ref:FormeleDivisieRef">
    <xsl:element name="vt:DivisieRef" namespace="{$uri_new[16]}">
      <xsl:apply-templates select="@xlink:href"/>
    </xsl:element>
  </xsl:template>

  <!-- transformeer activiteit -->

  <xsl:template name="activiteit">
    <xsl:if test="$activiteit">
      <xsl:result-document href="activiteit.xml" method="xml">
        <xsl:apply-templates select="$activiteit/node()"/>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <xsl:template match="rol:Activiteit">
    <xsl:element name="{name()}" namespace="{$uri_new[15]}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="(ow:status,ow:procedurestatus,rol:identificatie,rol:naam,rol:groep,rol:gerelateerdeActiviteit,rol:bovenliggendeActiviteit)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="rol:Activiteit/rol:groep">
    <xsl:variable name="waarde" select="$waardelijsten[titel='Activiteitengroep']/waarden/waarde[lower-case(label)=lower-case(current())]/uri"/>
    <xsl:choose>
      <xsl:when test="$waarde">
        <xsl:element name="{name()}" namespace="{$uri_new[15]}">
          <xsl:value-of select="$waarde"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:comment>
          <xsl:value-of select="concat('Let op: waarde &quot;',current(),'&quot; ontbreekt in waardelijst &quot;Activiteitengroep&quot;')"/>
        </xsl:comment>
        <xsl:element name="{name()}" namespace="{$uri_new[15]}">
          <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/onbekend')"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- transformeer gebiedsaanwijzing -->

  <xsl:template name="gebiedsaanwijzing">
    <xsl:if test="$gebiedsaanwijzing">
      <xsl:result-document href="gebiedsaanwijzing.xml" method="xml">
        <xsl:apply-templates select="$gebiedsaanwijzing/node()"/>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <xsl:template match="ga:Gebiedsaanwijzing">
    <xsl:element name="{name()}" namespace="{$uri_new[6]}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="(ow:status,ow:procedurestatus,ga:identificatie,ga:type,ga:naam,ga:groep,ga:locatieaanduiding)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ga:type">
    <xsl:variable name="waarde" select="$waardelijsten[titel='TypeGebiedsaanwijzing']/waarden/waarde[lower-case(label)=lower-case(current())]/uri"/>
    <xsl:choose>
      <xsl:when test="$waarde">
        <xsl:element name="{name()}" namespace="{$uri_new[6]}">
          <xsl:value-of select="$waarde"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:comment>
          <xsl:value-of select="concat('Let op: waarde &quot;',current(),'&quot; ontbreekt in waardelijst &quot;TypeGebiedsaanwijzing&quot;')"/>
        </xsl:comment>
        <xsl:element name="{name()}" namespace="{$uri_new[6]}">
          <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/onbekend')"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="ga:groep">
    <xsl:variable name="groep" select="($waardelijsten[contains(lower-case(titel),lower-case(current()/preceding-sibling::ga:type))]|$waardelijsten[contains(lower-case(label),lower-case(current()/preceding-sibling::ga:type))])[1]"/>
    <xsl:variable name="waarde" select="$groep/waarden/waarde[lower-case(label)=lower-case(current())]/uri"/>
    <xsl:choose>
      <xsl:when test="$waarde">
        <xsl:element name="{name()}" namespace="{$uri_new[6]}">
          <xsl:value-of select="$waarde"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:comment>
          <xsl:value-of select="concat('Let op: waarde &quot;',current(),'&quot; ontbreekt in waardelijst &quot;',$groep/titel,'&quot;')"/>
        </xsl:comment>
        <xsl:element name="{name()}" namespace="{$uri_new[6]}">
          <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/onbekend')"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- transformeer normwaarde -->

  <xsl:template name="normwaarde">
    <xsl:if test="$normwaarde">
      <xsl:result-document href="normwaarde.xml" method="xml">
        <xsl:apply-templates select="$normwaarde/node()"/>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <xsl:template match="rol:Omgevingswaarde">
    <xsl:element name="{name()}" namespace="{$uri_new[15]}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="(ow:status,ow:procedurestatus,rol:identificatie,rol:naam)"/>
      <xsl:comment>Let op: hier type norm toevoegen</xsl:comment>
      <xsl:element name="rol:type" namespace="{$uri_new[15]}">
        <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/typenorm/id/concept/TypeNorm')"/>
      </xsl:element>
      <xsl:apply-templates select="(descendant::da:eenheid[1],rol:normwaarde,rol:groep)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="rol:Omgevingswaarde/rol:groep">
    <xsl:variable name="waarde" select="$waardelijsten[titel='Omgevingswaardegroep']/waarden/waarde[lower-case(label)=lower-case(current())]/uri"/>
    <xsl:choose>
      <xsl:when test="$waarde">
        <xsl:element name="{name()}" namespace="{$uri_new[15]}">
          <xsl:value-of select="$waarde"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:comment>
          <xsl:value-of select="concat('Let op: waarde &quot;',current(),'&quot; ontbreekt in waardelijst &quot;Omgevingswaardegroep&quot;')"/>
        </xsl:comment>
        <xsl:element name="{name()}" namespace="{$uri_new[15]}">
          <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/onbekend')"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="rol:Omgevingsnorm">
    <xsl:element name="{name()}" namespace="{$uri_new[15]}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="(ow:status,ow:procedurestatus,rol:identificatie,rol:naam)"/>
      <xsl:comment>Let op: hier type norm toevoegen</xsl:comment>
      <xsl:element name="rol:type" namespace="{$uri_new[15]}">
        <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/typenorm/id/concept/TypeNorm')"/>
      </xsl:element>
      <xsl:apply-templates select="(descendant::da:eenheid[1],rol:normwaarde,rol:groep)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="rol:Omgevingsnorm/rol:groep">
    <xsl:variable name="waarde" select="$waardelijsten[titel='Omgevingsnormgroep']/waarden/waarde[lower-case(label)=lower-case(current())]/uri"/>
    <xsl:choose>
      <xsl:when test="$waarde">
        <xsl:element name="{name()}" namespace="{$uri_new[15]}">
          <xsl:value-of select="$waarde"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:comment>
          <xsl:value-of select="concat('Let op: waarde &quot;',current(),'&quot; ontbreekt in waardelijst &quot;Omgevingsnormgroep&quot;')"/>
        </xsl:comment>
        <xsl:element name="{name()}" namespace="{$uri_new[15]}">
          <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/onbekend')"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="rol:Normwaarde">
    <xsl:variable name="ID03" select="count(.|preceding::rol:Normwaarde)"/>
    <xsl:element name="{name()}" namespace="{$uri_new[15]}">
      <xsl:apply-templates select="@*"/>
      <xsl:element name="rol:identificatie" namespace="{$uri_new[15]}">
        <xsl:value-of select="concat('nl.imow-',$ID01,'.normwaarde.',$ID02,format-number($ID03,'000000'))"/>
      </xsl:element>
      <xsl:apply-templates select="(rol:kwalitatieveWaarde,rol:kwantitatieveWaarde,rol:waardeInRegeltekst,rol:specifiekeSymbolisatie,rol:locatieaanduiding)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="rol:kwalitatieveWaarde">
    <xsl:element name="{name()}" namespace="{$uri_new[15]}">
      <xsl:value-of select="text()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="rol:kwantitatieveWaarde">
    <xsl:element name="{name()}" namespace="{$uri_new[15]}">
      <xsl:value-of select="da:waarde/text()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="da:eenheid">
    <xsl:variable name="waarde" select="$waardelijsten[titel='Eenheid']/waarden/waarde[lower-case(label)=lower-case(current())]/uri"/>
    <xsl:choose>
      <xsl:when test="$waarde">
        <xsl:element name="{fn:string-join(($ns_new[15],local-name()),':')}" namespace="{$uri_new[15]}">
          <xsl:value-of select="$waarde"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:comment>
          <xsl:value-of select="concat('Let op: waarde &quot;',current(),'&quot; ontbreekt in waardelijst &quot;Eenheid&quot;')"/>
        </xsl:comment>
        <xsl:element name="{fn:string-join(($ns_new[15],local-name()),':')}" namespace="{$uri_new[15]}">
          <xsl:value-of select="string('http://standaarden.omgevingswet.overheid.nl/onbekend')"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- transformeer locatie -->

  <xsl:template name="locatie">
    <xsl:if test="$locatie">
      <xsl:result-document href="locatie.xml" method="xml">
        <xsl:apply-templates select="$locatie/node()"/>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <!-- transformeer pons -->

  <xsl:template name="pons">
    <xsl:if test="$pons">
      <xsl:result-document href="pons.xml" method="xml">
        <xsl:apply-templates select="$pons/node()"/>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <xsl:template match="p:Pons">
    <xsl:element name="{name()}" namespace="{$uri_new[11]}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="(ow:status,ow:procedurestatus,p:identificatie,p:locatieaanduiding)"/>
    </xsl:element>
  </xsl:template>

  <!-- transformeer kaart -->

  <xsl:template name="kaart">
    <xsl:if test="$kaart">
      <xsl:result-document href="kaart.xml" method="xml">
        <xsl:apply-templates select="$kaart/node()"/>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <xsl:template match="k:Kaart">
    <xsl:element name="{name()}" namespace="{$uri_new[8]}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="(ow:status,ow:procedurestatus,k:identificatie,k:kaartnaam,k:kaartnummer,k:kaartuitsnede,k:kaartlagen)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="k:kaartnaam">
    <xsl:element name="k:naam" namespace="{$uri_new[8]}">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="k:kaartnummer">
    <xsl:element name="k:nummer" namespace="{$uri_new[8]}">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="k:kaartuitsnede">
    <xsl:element name="k:uitsnede" namespace="{$uri_new[8]}">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="k:Kaartextent">
    <xsl:element name="{name()}" namespace="{$uri_new[8]}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="(k:minX,k:minY,k:maxX,k:maxY)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="k:Kaartlaag">
    <xsl:element name="{name()}" namespace="{$uri_new[8]}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="(ow:status,ow:procedurestatus,k:identificatie,k:naam)"/>
      <xsl:element name="k:niveau" namespace="{$uri_new[8]}">
        <xsl:value-of select="count(.|preceding-sibling::k:Kaartlaag)"/>
      </xsl:element>
      <xsl:apply-templates select="(k:symbolisatieItems)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="k:symbolisatieItems">
    <xsl:variable name="objecttype" select="('Activiteit','Gebiedsaanwijzing','Normwaarde','Omgevingsnorm','Omgevingswaarde')"/>
    <xsl:variable name="object" select="('k:activiteitlocatieweergave','k:gebiedsaanwijzingweergave','k:normweergave','k:normweergave','k:normweergave')"/>
    <xsl:for-each-group select="k:SymbolisatieItem" group-by="k:objecttype">
      <xsl:for-each select="current-grouping-key()">
        <xsl:variable name="index" select="fn:index-of($objecttype,.)"/>
        <xsl:element name="{$object[$index]}" namespace="{$uri_new[8]}">
          <xsl:apply-templates select="current-group()"/>
        </xsl:element>
      </xsl:for-each>
    </xsl:for-each-group>
  </xsl:template>

  <xsl:template match="k:SymbolisatieItem">
    <xsl:choose>
      <xsl:when test="k:objecttype='Activiteit'">
        <xsl:for-each select="$activiteit//rol:Activiteit[*[local-name()=current()/k:filterattribuut/k:attribuut]=current()/k:filterattribuut/k:waardediscreet]/rol:identificatie">
          <xsl:element name="r:ActiviteitLocatieaanduidingRef" namespace="{$uri_new[13]}">
            <xsl:attribute name="xlink:href" select="."/>
          </xsl:element>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="k:objecttype='Gebiedsaanwijzing'">
        <xsl:for-each select="$gebiedsaanwijzing//ga:Gebiedsaanwijzing[*[local-name()=current()/k:filterattribuut/k:attribuut]=current()/k:filterattribuut/k:waardediscreet]/ga:identificatie">
          <xsl:element name="ga:GebiedsaanwijzingRef" namespace="{$uri_new[6]}">
            <xsl:attribute name="xlink:href" select="."/>
          </xsl:element>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="k:objecttype='Normwaarde'">
        <xsl:for-each select="$normwaarde//rol:Normwaarde[*[local-name()=current()/k:filterattribuut/k:attribuut]=current()/k:filterattribuut/k:waardediscreet]/rol:identificatie">
          <xsl:element name="rol:NormRef" namespace="{$uri_new[15]}">
            <xsl:attribute name="xlink:href" select="."/>
          </xsl:element>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="k:objecttype='Omgevingsnorm'">
        <xsl:for-each select="$normwaarde//rol:Omgevingsnorm[*[local-name()=current()/k:filterattribuut/k:attribuut]=current()/k:filterattribuut/k:waardediscreet]/rol:identificatie">
          <xsl:element name="rol:OmgevingsnormRef" namespace="{$uri_new[15]}">
            <xsl:attribute name="xlink:href" select="."/>
          </xsl:element>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="k:objecttype='Omgevingswaarde'">
        <xsl:for-each select="$normwaarde//rol:Omgevingswaarde[*[local-name()=current()/k:filterattribuut/k:attribuut]=current()/k:filterattribuut/k:waardediscreet]/rol:identificatie">
          <xsl:element name="rol:OmgevingswaardeRef" namespace="{$uri_new[15]}">
            <xsl:attribute name="xlink:href" select="."/>
          </xsl:element>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- transformeer hoofdlijn -->

  <xsl:template name="hoofdlijn">
    <xsl:if test="$hoofdlijn">
      <xsl:result-document href="hoofdlijn.xml" method="xml">
        <xsl:apply-templates select="$hoofdlijn/node()"/>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <xsl:template match="vt:Hoofdlijn">
    <xsl:element name="{name()}" namespace="{$uri_new[17]}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="(ow:status,ow:procedurestatus,vt:identificatie,vt:soort,vt:naam,vt:gerelateerdeHoofdlijn)"/>
    </xsl:element>
  </xsl:template>

  <!-- transformeer manifest-ow -->

  <xsl:template name="manifest_ow">
    <xsl:if test="$manifest_ow">
      <xsl:result-document href="manifest_ow.xml" method="xml">
        <xsl:apply-templates select="$manifest_ow/node()"/>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*:Modules">
    <xsl:element name="Aanleveringen" namespace="{$xmlns}">
      <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('http://www.geostandaarden.nl/bestanden-ow/manifest-ow https://register.geostandaarden.nl/xmlschema/tpod/v1.0.2/bestanden-ow/generiek/manifest-ow.xsd')"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*:RegelingVersie">
    <xsl:element name="Aanlevering" namespace="{$xmlns}">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*:FRBRwork">
    <xsl:element name="WorkIDRegeling" namespace="{$xmlns}">
      <xsl:value-of select="document($file.config)//WorkID"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*:FRBRExpression">
    <xsl:element name="DoelID" namespace="{$xmlns}">
      <xsl:value-of select="document($file.config)//DoelID"/>
    </xsl:element>
  </xsl:template>

  <!-- vervallen attributen -->

  <xsl:template match="@*[name()=('ow:regeltekstId','rkow:regeltekstId','wIdRegeling')]">
    <!-- doe niets -->
  </xsl:template>

  <!-- algemene templates -->

  <xsl:template match="element()">
    <xsl:variable name="index" select="fn:index-of($uri_old,namespace-uri())"/>
    <xsl:element name="{fn:string-join(($ns_new[$index],local-name()),':')}" namespace="{($uri_new[$index],$xmlns)[1]}">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()">
    <xsl:copy-of select="."/>
  </xsl:template>

</xsl:stylesheet>