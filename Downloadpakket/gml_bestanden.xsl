<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:digest="java:org.apache.commons.codec.digest.DigestUtils" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/" xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/" xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0" xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:l="http://www.geostandaarden.nl/imow/locatie">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
  <!-- de transformatie zet een downloadpakketje om naar publicatie van een initieel besluit -->

  <xsl:param name="base.dir" select="fn:tokenize(fn:base-uri(.),'input')[1]"/>
  <xsl:param name="input.dir" select="concat($base.dir,'input/')"/>
  <xsl:param name="temp.dir" select="concat($base.dir,'temp/')"/>
  <xsl:param name="output.dir" select="concat($base.dir,'output/')"/>

  <!-- namespaces LVBB -->
  <xsl:param name="lvbb" select="string('http://www.overheid.nl/2017/lvbb')"/>
  <!-- namespaces OP -->
  <xsl:param name="data" select="string('https://standaarden.overheid.nl/stop/imop/data/')"/>
  <xsl:param name="tekst" select="string('https://standaarden.overheid.nl/stop/imop/tekst/')"/>
  <xsl:param name="dso" select="string('https://www.dso.nl/')"/>
  <xsl:param name="basisgeo" select="string('http://www.geostandaarden.nl/basisgeometrie/1.0')"/>
  <xsl:param name="geo" select="string('https://standaarden.overheid.nl/stop/imop/geo/')"/>
  <xsl:param name="gio" select="string('https://standaarden.overheid.nl/stop/imop/gio/')"/>
  <xsl:param name="gml" select="string('http://www.opengis.net/gml/3.2')"/>
  <xsl:param name="aan" select="string('https://standaarden.overheid.nl/lvbb/stop/aanlevering/')"/>
  <xsl:param name="uit" select="string('https://standaarden.overheid.nl/stop/imop/uitwisseling/')"/>
  <!-- namespaces OW -->
  <xsl:param name="da" select="string('http://www.geostandaarden.nl/imow/datatypenalgemeen')"/>
  <xsl:param name="ga" select="string('http://www.geostandaarden.nl/imow/gebiedsaanwijzing')"/>
  <xsl:param name="k" select="string('http://www.geostandaarden.nl/imow/kaart')"/>
  <xsl:param name="l" select="string('http://www.geostandaarden.nl/imow/locatie')"/>
  <xsl:param name="manifest" select="string('http://www.geostandaarden.nl/bestanden-ow/manifest-ow')"/>
  <xsl:param name="ow" select="string('http://www.geostandaarden.nl/imow/owobject')"/>
  <xsl:param name="ow-dc" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand')"/>
  <xsl:param name="p" select="string('http://www.geostandaarden.nl/imow/pons')"/>
  <xsl:param name="r" select="string('http://www.geostandaarden.nl/imow/regels')"/>
  <xsl:param name="rg" select="string('http://www.geostandaarden.nl/imow/regelingsgebied')"/>
  <xsl:param name="rol" select="string('http://www.geostandaarden.nl/imow/regelsoplocatie')"/>
  <xsl:param name="sl" select="string('http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek')"/>
  <xsl:param name="vt" select="string('http://www.geostandaarden.nl/imow/vrijetekst')"/>
  <!-- algemeen -->
  <xsl:param name="xlink" select="string('http://www.w3.org/1999/xlink')"/>
  <xsl:param name="xsi" select="string('http://www.w3.org/2001/XMLSchema-instance')"/>

  <!-- bestanden -->
  <xsl:param name="regeling_identificatie" select="document(concat($input.dir,'Regeling/Regeling-Identificatie.xml'))/element()"/>
  <xsl:param name="regeling_metadata" select="document(concat($input.dir,'Regeling/Regeling-Metadata.xml'))/element()"/>
  <xsl:param name="regeling_tekst" select="document(concat($input.dir,'Regeling/Regeling-Tekst.xml'))/element()"/>
  <xsl:param name="regeling_versieMetadata" select="document(concat($input.dir,'Regeling/Regeling-VersieMetadata.xml'))/element()"/>
  <xsl:param name="regeling_ow" select="document(concat($input.dir,'OW-bestanden/manifest-ow.xml'))/element()"/>

  <!-- parameters -->
  <xsl:param name="id_bg_code" select="fn:tokenize($regeling_metadata/data:eindverantwoordelijke,'/')[last()]"/>
  <xsl:param name="id_levering" select="digest:md5Hex(fn:string-join($regeling_tekst//text()))"/>
  <xsl:param name="id_bill_work" select="fn:string-join(('','akn','nl','bill',$id_bg_code,fn:format-date(current-date(),'[Y0001]'),$id_levering),'/')"/>
  <xsl:param name="id_bill_expression" select="fn:string-join(($id_bill_work,concat('nld@',format-date(current-date(),'[Y0001]-[M01]-[D01]'),';1')),'/')"/>
  <xsl:param name="id_doel" select="$regeling_ow//(DoelID)[1]" as="xs:string" xpath-default-namespace="http://www.geostandaarden.nl/bestanden-ow/manifest-ow"/>

  <!-- oin -->
  <xsl:param name="oin" select="document('OIN.xml')/lijst"/>
  <xsl:param name="oin_code" select="$oin/item[fn:ends-with(BG,$id_bg_code)]/OIN"/>
  <xsl:param name="oin_naam" select="$oin/item[fn:ends-with(BG,$id_bg_code)]/naam"/>

  <!-- filelist -->

  <xsl:param name="filelist">
    <xsl:analyze-string select="unparsed-text(concat($temp.dir,'/log_filelist.txt'))" regex="nl(.*) moved to (.*)">
      <xsl:matching-substring>
        <xsl:element name="informatieobject">
          <xsl:element name="join">
            <xsl:value-of select="regex-group(1)"/>
          </xsl:element>
          <xsl:element name="bg-code">
            <xsl:value-of select="fn:tokenize(regex-group(1),'/')[5]"/>
          </xsl:element>
          <xsl:element name="dc-jaar">
            <xsl:value-of select="fn:tokenize(regex-group(1),'/')[6]"/>
          </xsl:element>
          <xsl:element name="dc-id">
            <xsl:value-of select="fn:tokenize(regex-group(2),'/')[4]"/>
          </xsl:element>
        </xsl:element>
      </xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:param>

  <!-- guids -->

  <xsl:param name="guids">
    <xsl:element name="ow">
      <xsl:for-each select="collection(concat($input.dir,'/OW-bestanden','?select=*.gml'))">
        <xsl:variable name="document" select="fn:tokenize(document-uri(.),'/')[last()]"/>
        <xsl:for-each select=".//basisgeo:Geometrie">
          <xsl:variable name="geometrie" select="."/>
          <xsl:variable name="content" as="xs:token*">
            <xsl:for-each select="fn:tokenize(fn:string-join($geometrie//gml:posList/text(),' '),'\s+')">
              <xsl:sort/>
              <xsl:value-of select="number(.)"/>
            </xsl:for-each>
          </xsl:variable>
          <xsl:element name="guid">
            <xsl:element name="id">
              <xsl:value-of select="$geometrie/basisgeo:id"/>
            </xsl:element>
            <xsl:element name="content">
              <xsl:value-of select="digest:md5Hex(fn:string-join($content, ''))"/>
            </xsl:element>
            <xsl:element name="document">
              <xsl:value-of select="$document"/>
            </xsl:element>
            <xsl:for-each select="collection(concat($input.dir,'/OW-bestanden','?select=*.xml'))//(l:Gebied[descendant::element()/@xlink:href=$geometrie/basisgeo:id],l:Ambtsgebied[descendant::l:bestuurlijkeGrenzenID=$geometrie/basisgeo:id])">
              <xsl:element name="noemer">
                <xsl:value-of select="./l:noemer"/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:element>
    <xsl:element name="op">
      <xsl:for-each select="collection(concat($temp.dir,'/gml','?select=*.gml'))">
        <xsl:variable name="document" select="fn:tokenize(document-uri(.),'/')[last()]"/>
        <xsl:for-each select=".//basisgeo:Geometrie">
          <xsl:variable name="geometrie" select="."/>
          <xsl:variable name="content" as="xs:token*">
            <xsl:for-each select="fn:tokenize(fn:string-join($geometrie//gml:posList/text(),' '),'\s+')">
              <xsl:sort/>
              <xsl:value-of select="number(.)"/>
            </xsl:for-each>
          </xsl:variable>
          <xsl:element name="guid">
            <xsl:element name="id">
              <xsl:value-of select="$geometrie/basisgeo:id"/>
            </xsl:element>
            <xsl:element name="content">
              <xsl:value-of select="digest:md5Hex(fn:string-join($content, ''))"/>
            </xsl:element>
            <xsl:element name="document">
              <xsl:value-of select="$document"/>
            </xsl:element>
            <xsl:for-each select="collection(concat($temp.dir,'/gml','?select=',$document))//geo:Locatie[descendant::basisgeo:id=$geometrie/basisgeo:id]">
              <xsl:element name="noemer">
                <xsl:value-of select="./geo:naam"/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:for-each>
      </xsl:for-each>    
    </xsl:element>
  </xsl:param>

  <xsl:param name="refs">
    <xsl:for-each select="fn:distinct-values(collection(concat($input.dir,'/OW-bestanden','?select=gebieden.xml'))//element()/@xlink:href)">
      <xsl:element name="ref">
        <xsl:attribute name="index" select="position()"/>
        <xsl:value-of select="."/>
      </xsl:element>
    </xsl:for-each>
  </xsl:param>

  <!-- bouw de bestanden op -->

  <xsl:template match="/">
    <xsl:call-template name="test"/>
    <xsl:element name="informatieobjectRefs">
      <xsl:for-each select="$filelist/informatieobject">
        <xsl:variable name="informatieobject" select="."/>
        <xsl:variable name="index" select="position()"/>
        <xsl:variable name="naam" select="concat(fn:format-number($index,'0000'),'_',$informatieobject/dc-id)"/>
        <xsl:variable name="gml" select="document(concat('https://repository-eto.officiele-overheidspublicaties.nl/Datacollecties/',$informatieobject/dc-jaar,'/',$informatieobject/dc-id,'/1/gml/',$informatieobject/dc-id,'.gml'))/node()"/>
        <!-- gml -->
        <xsl:result-document href="{concat($temp.dir,'gml/',$naam,'.gml')}" method="xml">
          <xsl:apply-templates select="$gml"/>
        </xsl:result-document>
        <!-- log -->
        <xsl:apply-templates select="$informatieobject"/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template name="test">
    <!-- dit is een tijdelijke routine om te achterhalen of guids zowel aan de ow-kant als aan de op-kant voorkomen -->
    <xsl:result-document href="{concat($temp.dir,'test.xml')}" method="xml">
      <xsl:element name="test">
        <xsl:comment><xsl:text>elk ref in gebieden.xml, met een verwijzing naar de documenten in OP en OW waarin die voorkomt.</xsl:text></xsl:comment>
        <xsl:element name="refs">
          <xsl:for-each select="$refs/ref">
            <xsl:variable name="ref" select="."/>
            <xsl:element name="ref">
              <xsl:attribute name="index" select="position()"/>
              <xsl:attribute name="id" select="$ref"/>
              <xsl:for-each select="$guids//guid[./id=$ref]">
                <xsl:element name="document">
                  <xsl:attribute name="type" select="./(ancestor::op|ancestor::ow)/name()"/>
                  <xsl:value-of select="./document"/>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
        <xsl:comment><xsl:text>elke noemer, met een verwijzing naar de documenten in OP en OW met een overeenkomstige noemer</xsl:text></xsl:comment>
        <xsl:element name="noemers">
          <xsl:for-each-group select="$guids//guid" group-by="noemer">
            <xsl:element name="noemer">
              <xsl:attribute name="index" select="position()"/>
              <xsl:attribute name="waarde" select="current-grouping-key()"/>
              <xsl:for-each select="current-group()/self::guid">
                <xsl:element name="document">
                  <xsl:attribute name="type" select="./(ancestor::op|ancestor::ow)/name()"/>
                  <xsl:value-of select="./document"/>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
          </xsl:for-each-group>
        </xsl:element>
        <xsl:comment><xsl:text>elke content bevat de hash van de onderliggende posList, met een verwijzing naar de documenten in OP en OW waarvan de hash van de onderliggende posList overeenkomt</xsl:text></xsl:comment>
        <xsl:element name="contents">
          <xsl:for-each select="fn:distinct-values($guids//content)">
            <xsl:variable name="content" select="."/>
            <xsl:element name="content">
              <xsl:attribute name="index" select="position()"/>
              <xsl:attribute name="hash" select="."/>
              <xsl:for-each select="$guids//guid[./content=$content]">
                <xsl:element name="document">
                  <xsl:attribute name="type" select="./(ancestor::op|ancestor::ow)/name()"/>
                  <xsl:attribute name="id" select="./id"/>
                  <xsl:value-of select="./document"/>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
        <xsl:comment><xsl:text>guids</xsl:text></xsl:comment>
        <xsl:element name="guids">
          <xsl:for-each select="$guids//guid">
            <xsl:element name="guid">
              <xsl:attribute name="index" select="count(.|preceding-sibling::guid)"/>
              <xsl:attribute name="type" select="./(ancestor::op|ancestor::ow)/name()"/>
              <xsl:copy-of select="@*|element()"/>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:element>
    </xsl:result-document>
  </xsl:template>

  <!--xsl:template match="geo:GeoInformatieObjectVaststelling">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:namespace name="geo" select="$geo"/>
      <xsl:namespace name="basisgeo" select="$basisgeo"/>
      <xsl:namespace name="gml" select="$gml"/>
      <xsl:attribute name="schemaversie" select="string('1.3.0')"/>
      <xsl:attribute name="xsi:schemaLocation" namespace="{$xsi}" select="string('https://standaarden.overheid.nl/stop/imop/geo/ https://standaarden.overheid.nl/stop/1.3.0/imop-geo.xsd')"/>
      <xsl:apply-templates select="./node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="basisgeo:Geometrie">
    <xsl:variable name="hash">
      <xsl:value-of select="fn:string-join(.//gml:posList/translate(.,translate(., '0123456789', ''), ''))"/>
    </xsl:variable>
    <xsl:variable name="guid" select="$guids/guid[./hash=$hash]"/>
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:attribute name="gml:id" select="$guid"/>
      <xsl:apply-templates select="basisgeo:id">
        <xsl:with-param name="id" select="$guid"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="basisgeo:geometrie"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="basisgeo:id">
    <xsl:param name="id"/>
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:value-of select="$id"/>
    </xsl:element>
  </xsl:template-->

  <!-- algemeen -->

  <xsl:template match="element()">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:choose>
      <xsl:when test="(normalize-space(.)='') and contains(.,'&#10;')">
        <!-- lege tekst met een zachte return is indentation -->
        <xsl:value-of select="fn:tokenize(.,'&#10;')[1]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="myArray">
          <xsl:value-of select="fn:tokenize(.,'\s+')"/>
        </xsl:variable>
        <xsl:value-of select="fn:concat($myArray,'')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="comment()">
    <xsl:copy-of select="."/>
  </xsl:template>

</xsl:stylesheet>