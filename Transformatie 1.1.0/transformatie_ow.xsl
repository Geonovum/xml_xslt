<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" xmlns:ow="http://www.geostandaarden.nl/imow/owobject" xmlns:da="http://www.geostandaarden.nl/imow/datatypenalgemeen" xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" xmlns:k="http://www.geostandaarden.nl/imow/kaart" xmlns:l="http://www.geostandaarden.nl/imow/locatie" xmlns:p="http://www.geostandaarden.nl/imow/pons" xmlns:r="http://www.geostandaarden.nl/imow/regels" xmlns:rg="http://www.geostandaarden.nl/imow/regelingsgebied" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst" xmlns:xlink="http://www.w3.org/1999/xlink" version="2.0">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
  <xsl:strip-space elements="*"/>

  <!-- doorgegeven parameters -->

  <xsl:param name="file.list"/>
  <xsl:param name="base.dir"/>
  <xsl:param name="temp.dir"/>

  <!-- waardelijsten -->

  <xsl:param name="waardelijsten" select="document(concat($base.dir,'/waardelijsten OW 2.0.0.xml'))//waardelijst"/>

  <!-- haal mapping akn op -->

  <xsl:param name="wId_bg" select="collection(concat($temp.dir,'?select=akn.xml'))/map/@wId_bg" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
  <xsl:param name="wId_versie" select="collection(concat($temp.dir,'?select=akn.xml'))/map/@wId_versie" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
  <xsl:param name="wId_oin" select="collection(concat($base.dir,'?select=OIN.xml'))//item[fn:ends-with(BG,$wId_bg)]"/>
  <xsl:param name="akn" select="collection(concat($temp.dir,'?select=akn.xml'))//node[@gewijzigd=true()]" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>

  <!-- stel manifest-bestand samen -->

  <xsl:param name="manifest">
    <xsl:for-each select="tokenize($file.list,';')">
      <xsl:variable name="fullname" select="."/>
      <xsl:choose>
        <xsl:when test="document($fullname)//(l:AmbtsgebiedRef|l:GebiedRef|l:GebiedengroepRef|l:LijnRef|l:LijnengroepRef|l:LocatieRef|l:PuntRef|l:PuntengroepRef[fn:matches(@xlink:href,'(GM|PV|WS|LND)[A-Z0-9.]{1,7}')])" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand">
          <xsl:element name="ambtsgebied">
            <xsl:attribute name="type" select="string('verwijzing')"/>
            <xsl:copy-of select="document($fullname)//l:AmbtsgebiedRef/@xlink:href" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand"/>
          </xsl:element>
        </xsl:when>
        <xsl:when test="document($fullname)//l:Ambtsgebied" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand">
          <xsl:element name="ambtsgebied">
            <xsl:attribute name="type" select="string('object')"/>
            <xsl:copy-of select="document($fullname)//l:Ambtsgebied/node()" xpath-default-namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand"/>
          </xsl:element>
        </xsl:when>
      </xsl:choose>
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

  <!-- aanpassing divisie-divisietekst -->

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

  <!-- mapping thema -->

  <xsl:template match="r:thema|vt:thema">
    <xsl:variable name="uri" select="fn:tokenize(text(),'/')"/>
    <xsl:variable name="thema" select="$uri[4]"/>
    <xsl:variable name="subthema" select="$uri[7]"/>
    <xsl:variable name="waarde" select="$waardelijsten[./term='Thema']/waarden/waarde[lower-case(./uri)=fn:string-join(($uri[1],'',$uri[3],'thema',$uri[5],$uri[6],$uri[4]),'/')]"/>
    <!-- alleen de eerste van een thema plaatsen -->
    <xsl:if test="not((preceding-sibling::r:thema|preceding-sibling::vt:thema)/fn:tokenize(text(),'/')[4]=$thema)">
      <xsl:choose>
        <xsl:when test="$waarde">
          <xsl:element name="{name()}" namespace="{namespace-uri()}">
            <xsl:value-of select="$waarde/uri"/>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:comment><xsl:value-of select="concat('Waarde ''',text(),''' is niet gevonden in waardelijsten 2.0.0.')"/></xsl:comment>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!-- aanpassing ambtsgebied -->

  <xsl:template match="sl:standBestand[descendant::sl:objectType='Gebied']">
    <xsl:choose>
      <xsl:when test="$manifest/ambtsgebied[@type='verwijzing']">
        <xsl:choose>
          <xsl:when test="$manifest/ambtsgebied[@type='object']">
            <!-- als het ambtsgebied bestaat, deze opnemen -->
            <xsl:element name="{name()}" namespace="{namespace-uri()}">
              <xsl:apply-templates select="node()"/>
            </xsl:element>
          </xsl:when>
          <xsl:otherwise>
            <!-- als het ambtsgebied niet bestaat, deze samenstellen -->
            <xsl:element name="{name()}" namespace="{namespace-uri()}">
              <xsl:apply-templates select="node()"/>
              <xsl:element name="sl:stand">
                <xsl:element name="ow-dc:owObject">
                  <xsl:call-template name="l:Ambtsgebied"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- als er niet naar verwezen wordt, dan niet opnemen -->
        <xsl:element name="{name()}" namespace="{namespace-uri()}">
          <xsl:apply-templates select="node() except sl:stand[descendant::l:Ambtsgebied]"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="l:Ambtsgebied">
    <xsl:call-template name="l:Ambtsgebied"/>
  </xsl:template>

  <xsl:template name="l:Ambtsgebied">
    <xsl:element name="l:Ambtsgebied">
      <xsl:choose>
        <xsl:when test="fn:starts-with($wId_bg,'mnre')">
          <!-- ministeries krijgen allemaal ambstgebied 'landsgrens + territoriale wateren + EEZ' -->
          <xsl:element name="l:identificatie">
            <xsl:value-of select="concat('nl.imow-',$wId_bg,'.ambtsgebied.',$wId_oin/OIN)"/>
          </xsl:element>
          <xsl:element name="l:noemer">
            <xsl:value-of select="string('landsgrens + territoriale wateren + EEZ')"/>
          </xsl:element>
          <xsl:element name="l:bestuurlijkeGrenzenVerwijzing">
            <xsl:element name="l:BestuurlijkeGrenzenVerwijzing">
              <xsl:element name="l:bestuurlijkeGrenzenID">
                <xsl:value-of select="string('LND6030.B')"/>
              </xsl:element>
              <xsl:element name="l:domein">
                <xsl:value-of select="string('NL.BI.BestuurlijkGebied')"/>
              </xsl:element>
              <xsl:element name="l:geldigOp">
                <xsl:value-of select="string('2021-01-01')"/>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:element name="l:identificatie">
            <xsl:value-of select="concat('nl.imow-',$wId_bg,'.ambtsgebied.',$wId_oin/OIN)"/>
          </xsl:element>
          <xsl:element name="l:noemer">
            <xsl:value-of select="$wId_oin/naam"/>
          </xsl:element>
          <xsl:element name="l:bestuurlijkeGrenzenVerwijzing">
            <xsl:element name="l:BestuurlijkeGrenzenVerwijzing">
              <xsl:element name="l:bestuurlijkeGrenzenID">
                <xsl:value-of select="upper-case($wId_bg)"/>
              </xsl:element>
              <xsl:element name="l:domein">
                <xsl:value-of select="string('NL.BI.BestuurlijkGebied')"/>
              </xsl:element>
              <xsl:element name="l:geldigOp">
                <xsl:value-of select="string('2021-01-01')"/>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template match="sl:objectTypen[sl:objectType='Gebied']">
    <xsl:element name="sl:objectTypen">
      <!-- ambtsgebied alleen toevoegen als er naar verwezen wordt -->
      <xsl:if test="$manifest/ambtsgebied[@type='verwijzing']">
        <xsl:element name="sl:objectType">
          <xsl:value-of select="string('Ambtsgebied')"/>
        </xsl:element>
      </xsl:if>
      <xsl:apply-templates select="sl:objectType[.=('Gebied','Gebiedengroep')]"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Bestand[objecttype='Gebied']" xpath-default-namespace="http://www.geostandaarden.nl/bestanden-ow/manifest-ow">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:apply-templates select="naam" xpath-default-namespace="http://www.geostandaarden.nl/bestanden-ow/manifest-ow"/>
      <!-- ambtsgebied alleen toevoegen als er naar verwezen wordt -->
      <xsl:if test="$manifest/ambtsgebied[@type='verwijzing']" xpath-default-namespace="">
        <xsl:element name="objecttype" namespace="{namespace-uri()}">
          <xsl:value-of select="string('Ambtsgebied')"/>
        </xsl:element>
      </xsl:if>
      <xsl:apply-templates select="objecttype[.=('Gebied','Gebiedengroep')]"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="(l:AmbtsgebiedRef|l:GebiedRef|l:GebiedengroepRef|l:LijnRef|l:LijnengroepRef|l:LocatieRef|l:PuntRef|l:PuntengroepRef)[fn:matches(@xlink:href,'(GM|PV|WS|LND)[A-Z0-9.]{1,7}')]" priority="10">
    <xsl:choose>
      <xsl:when test="parent::element()/local-name()='locatieaanduiding'">
        <xsl:element name="l:LocatieRef">
          <xsl:attribute name="xlink:href" select="concat('nl.imow-',$wId_bg,'.ambtsgebied.',$wId_oin/OIN)"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="{name()}" namespace="{namespace-uri()}">
          <xsl:attribute name="xlink:href" select="concat('nl.imow-',$wId_bg,'.ambtsgebied.',$wId_oin/OIN)"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- aanpassing locatieaanduiding -->

  <xsl:template match="l:AmbtsgebiedRef|l:GebiedRef|l:GebiedengroepRef|l:LijnRef|l:LijnengroepRef|l:LocatieRef|l:PuntRef|l:PuntengroepRef">
    <xsl:choose>
      <xsl:when test="parent::element()/local-name()='locatieaanduiding'">
        <xsl:element name="l:LocatieRef">
          <xsl:copy-of select="@xlink:href"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="{name()}" namespace="{namespace-uri()}">
          <xsl:copy-of select="@xlink:href"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
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