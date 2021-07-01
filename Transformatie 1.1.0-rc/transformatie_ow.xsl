<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" xmlns:ow="http://www.geostandaarden.nl/imow/owobject" xmlns:da="http://www.geostandaarden.nl/imow/datatypenalgemeen" xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" xmlns:k="http://www.geostandaarden.nl/imow/kaart" xmlns:l="http://www.geostandaarden.nl/imow/locatie" xmlns:p="http://www.geostandaarden.nl/imow/pons" xmlns:r="http://www.geostandaarden.nl/imow/regels" xmlns:rg="http://www.geostandaarden.nl/imow/regelingsgebied" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst" xmlns:xlink="http://www.w3.org/1999/xlink" version="2.0">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
  <xsl:strip-space elements="*"/>

  <!-- doorgegeven parameters -->

  <xsl:param name="file.list" select="string('file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_001.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_002.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_003.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_004.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_005.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_006.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_007.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_008.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_009.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_010.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_011.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_012.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_013.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_014.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_015.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_016.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_017.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_018.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_019.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_020.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_021.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_022.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_023.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_024.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_025.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_026.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_027.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_028.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_029.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_030.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_031.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_032.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_033.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_034.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_035.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_036.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_037.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_038.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_039.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_040.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_041.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_042.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_043.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_044.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_045.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_046.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_047.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_048.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_049.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_050.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_051.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_052.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_053.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_054.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_055.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_056.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_057.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_058.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_059.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_060.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_061.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_062.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_063.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_064.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_065.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_066.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_067.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_068.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_069.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_070.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_071.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_072.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_073.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_074.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_075.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_076.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_077.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_078.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_079.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_080.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_081.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_082.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_083.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/GIO_084.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/OVIPU002.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/manifest-ow.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/manifest.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/opdracht.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/owDivisie.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/owGebiedsaanwijzing.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/owHoofdlijn.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/owKaart.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/owLocatie.xml;file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/1.0.4/opdracht/owRegelingsgebied.xml')"/>
  <xsl:param name="temp.dir" select="string('file:/C:/Werkbestanden/Geonovum/Transformatie 1.1.0-rc/temp')"/>

  <!-- haal mapping akn op -->

  <xsl:param name="wId_bg" select="collection(concat($temp.dir,'?select=akn.xml'))/map/@wId_bg" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
  <xsl:param name="wId_versie" select="collection(concat($temp.dir,'?select=akn.xml'))/map/@wId_versie" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
  <xsl:param name="akn" select="collection(concat($temp.dir,'?select=akn.xml'))//node[@gewijzigd=true()]" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>

  <!-- stel manifest-bestand samen -->

  <xsl:param name="manifest">
    <xsl:for-each select="tokenize($file.list,';')">
      <xsl:variable name="fullname" select="."/>
      <xsl:choose>
        <xsl:when test="document($fullname)//r:Regeltekst" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('regeltekst.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="$fullname"/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize($fullname,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document($fullname)//vt:Divisie" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('vrijetekst.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="$fullname"/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize($fullname,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document($fullname)//rol:Activiteit" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('activiteit.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="$fullname"/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize($fullname,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document($fullname)//ga:Gebiedsaanwijzing" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('gebiedsaanwijzing.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="$fullname"/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize($fullname,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document($fullname)//rol:Normwaarde" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('normwaarde.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="$fullname"/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize($fullname,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document($fullname)//l:Gebied" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('locatie.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="$fullname"/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize($fullname,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document($fullname)//p:Pons" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('pons.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="$fullname"/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize($fullname,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document($fullname)//k:Kaart" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('kaart.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="$fullname"/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize($fullname,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document($fullname)//rg:Regelingsgebied" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('regelingsgebied.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="$fullname"/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize($fullname,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document($fullname)//vt:Hoofdlijn" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('hoofdlijn.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="$fullname"/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize($fullname,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document($fullname)//Aanleveringen" xpath-default-namespace="http://www.geostandaarden.nl/bestanden-ow/manifest-ow">
          <xsl:element name="file">
            <xsl:attribute name="name" select="string('manifest_ow.xml')"/>
            <xsl:element name="fullname">
              <xsl:value-of select="$fullname"/>
            </xsl:element>
            <xsl:element name="name">
              <xsl:value-of select="tokenize($fullname,'/')[last()]"/>
            </xsl:element>
          </xsl:element>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:param>

  <!-- verwerk ow-bestanden -->

  <xsl:template match="/">
    <xsl:element name="manifest">
      <xsl:for-each select="$manifest/file">
        <xsl:copy-of select="."/>
        <xsl:call-template name="bestand">
          <xsl:with-param name="name" select="./@name"/>
          <xsl:with-param name="fullname" select="./fullname"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <!-- transformeer generieke zaken -->

  <xsl:template name="bestand">
    <xsl:param name="name"/>
    <xsl:param name="fullname"/>
    <xsl:variable name="document" select="document($fullname)"/>
    <xsl:result-document href="{$name}" method="xml">
      <xsl:apply-templates select="$document/node()"/>
    </xsl:result-document>
  </xsl:template>

  <xsl:template match="owBestand" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand">
    <xsl:element name="ow-dc:owBestand" namespace="{namespace-uri()}">
      <xsl:copy-of select="@*|namespace::*"/>
      <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand https://register.geostandaarden.nl/xmlschema/tpod/v2.0.0/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd')"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Aanleveringen" xpath-default-namespace="http://www.geostandaarden.nl/bestanden-ow/manifest-ow">
    <xsl:element name="Aanleveringen" namespace="{namespace-uri()}">
      <xsl:copy-of select="@*|namespace::*"/>
      <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('http://www.geostandaarden.nl/bestanden-ow/manifest-ow https://register.geostandaarden.nl/xmlschema/tpod/v2.0.0/bestanden-ow/generiek/manifest-ow.xsd')"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="r:Regeltekst|vt:Divisie">
    <xsl:variable name="wId" select="@wId"/>
    <!-- voor de omzetting van ow-bestanden is alleen Divisie van belang -->
    <xsl:variable name="node" select="$akn[concat($wId_bg,'_',$wId_versie,'__',./fn:tokenize(@oud,'\|')[1])=$wId]"/>
    <xsl:choose>
      <xsl:when test="$node">
        <xsl:choose>
          <xsl:when test="contains($node/@eId,'content')">
            <xsl:variable name="wId" select="replace(@wId,$node/@oud,$node/@eId)"/>
            <xsl:element name="vt:Divisietekst">
              <xsl:attribute name="wId" select="replace(@wId,$node/@oud,$node/@eId)"/>
              <xsl:apply-templates select="node()">
                <xsl:with-param name="wId" select="$wId"/>
              </xsl:apply-templates>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="{name()}" namespace="{namespace-uri()}">
              <xsl:attribute name="wId" select="replace(@wId,$node/@oud,$node/@eId)"/>
              <xsl:apply-templates select="node()"/>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="{name()}" namespace="{namespace-uri()}">
          <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="vt:identificatie">
    <xsl:param name="wId"/>
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:apply-templates select="@*"/>
      <xsl:choose>
        <xsl:when test="contains($wId,'content')">
          <xsl:value-of select="replace(.,'divisie','divisietekst')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template match="vt:DivisieRef">
    <xsl:variable name="id" select="@xlink:href"/>
    <xsl:variable name="wId" select="ancestor::sl:standBestand//vt:Divisie[vt:identificatie=$id]/@wId"/>
    <xsl:variable name="node" select="$akn[concat($wId_bg,'_',$wId_versie,'__',./fn:tokenize(@oud,'\|')[1])=$wId]"/>
    <xsl:choose>
      <xsl:when test="$node">
        <xsl:choose>
          <xsl:when test="contains($node/@eId,'content')">
            <xsl:element name="vt:DivisietekstRef">
              <xsl:attribute name="xlink:href" select="replace($id,'divisie','divisietekst')"/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <xsl:element name="{name()}" namespace="{namespace-uri()}">
              <xsl:apply-templates select="@*|node()"/>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="{name()}" namespace="{namespace-uri()}">
          <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="sl:objectTypen[sl:objectType='Divisie']">
    <xsl:element name="sl:objectTypen">
      <xsl:element name="sl:objectType">
        <xsl:value-of select="string('Divisie')"/>
      </xsl:element>
      <xsl:element name="sl:objectType">
        <xsl:value-of select="string('Divisietekst')"/>
      </xsl:element>
      <xsl:element name="sl:objectType">
        <xsl:value-of select="string('Tekstdeel')"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Bestand[objecttype='Divisie']" xpath-default-namespace="http://www.geostandaarden.nl/bestanden-ow/manifest-ow">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:apply-templates select="naam" xpath-default-namespace="http://www.geostandaarden.nl/bestanden-ow/manifest-ow"/>
      <xsl:element name="objecttype" namespace="{namespace-uri()}">
        <xsl:value-of select="string('Divisie')"/>
      </xsl:element>
      <xsl:element name="objecttype" namespace="{namespace-uri()}">
        <xsl:value-of select="string('Divisietekst')"/>
      </xsl:element>
      <xsl:element name="objecttype" namespace="{namespace-uri()}">
        <xsl:value-of select="string('Tekstdeel')"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- Algemene templates -->

  <xsl:template match="element()">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
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