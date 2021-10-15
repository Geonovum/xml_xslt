<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:my="http://mijn.eigen.ns" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0" xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:l="http://www.geostandaarden.nl/imow/locatie" xmlns:r="http://www.geostandaarden.nl/imow/regels" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst" xmlns:xlink="http://www.w3.org/1999/xlink">
  <xsl:output method="xhtml" encoding="UTF-8" indent="no" omit-xml-declaration="yes" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
  <xsl:strip-space elements="*"/>

  <xsl:param name="opdracht.dir" select="'C:/Werkbestanden/Geonovum/Overzicht/opdracht'"/>
  <xsl:param name="besluit" select="collection(concat('file:/',$opdracht.dir,'?select=*.xml;recurse=yes'))/AanleveringBesluit" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"/>

  <xsl:template match="/">
    <html>
      <head>
        <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
        <link rel="stylesheet" type="text/css" href="regeling.css"/>
        <title>
          <xsl:apply-templates select="$besluit//BesluitMetadata/officieleTitel/node()" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
        </title>
      </head>
      <body>
        <script type="text/javascript">function ShowHide(obj){var tbody = obj.parentNode.getElementsByTagName("tbody")[0];var old = tbody.style.display;tbody.style.display = (old == "none"?"":"none");}</script>
        <div class="content">
          <xsl:apply-templates select="$besluit//(RegelingCompact|RegelingKlassiek|RegelingTijdelijkdeel|RegelingVrijetekst|RegelingMutatie)/node()" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
        </div>
      </body>
    </html>
  </xsl:template>

  <!-- algemeen -->

  <xsl:template match="element()">
    <xsl:comment><xsl:value-of select="concat('[',name(),']')"/></xsl:comment>
    <xsl:apply-templates select="./node()"/>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:copy-of select="."/>
  </xsl:template>

  <!-- container -->

  <xsl:template match="Lichaam|Inhoud" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:apply-templates select="./node()"/>
  </xsl:template>

  <xsl:template match="Afdeling|Artikel|Boek|Deel|Hoofdstuk|Paragraaf|Subparagraaf|Subsubparagraaf|Titel" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:choose>
      <xsl:when test="fn:string-join(Kop/element(),'') ne ''">
        <section class="{lower-case(name())}">
          <xsl:apply-templates select="./node()"/>
        </section>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="./node()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="AlgemeneToelichting|ArtikelgewijzeToelichting|Bijlage|Divisie|Divisietekst|InleidendeTekst|Toelichting" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
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
    <section class="lid">
      <div class="lidnummer">
        <xsl:apply-templates select="./LidNummer"/>
      </div>
      <xsl:apply-templates select="./Inhoud"/>
    </section>
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

  <xsl:template match="Al" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
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
    <caption class="standaard">
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
    <thead class="standaard">
      <xsl:apply-templates select="*"/>
    </thead>
  </xsl:template>

  <xsl:template match="tbody" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <tbody class="standaard">
      <xsl:apply-templates select="*"/>
    </tbody>
  </xsl:template>

  <xsl:template match="row" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <tr class="standaard">
      <xsl:apply-templates select="*"/>
    </tr>
  </xsl:template>

  <xsl:template match="entry" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:variable name="colspan" select="number(substring(./@nameend,4))-number(substring(./@namest,4))+1"/>
    <xsl:variable name="rowspan" select="number(./(@morerows,'0')[1])+1"/>
    <xsl:choose>
      <xsl:when test="ancestor::thead" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
        <th class="standaard" colspan="{$colspan}" rowspan="{$rowspan}" style="{concat('text-align:',./@align)}">
          <xsl:apply-templates select="*"/>
        </th>
      </xsl:when>
      <xsl:when test="ancestor::tbody" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
        <td class="standaard" colspan="{$colspan}" rowspan="{$rowspan}" style="{concat('text-align:',./@align)}">
          <xsl:apply-templates select="*"/>
        </td>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- figuur -->

  <xsl:template match="Figuur" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:variable name="width">
      <!-- voor het geval er meer illustraties in een kader mogen, wordt de breedte berekend met sum -->
      <xsl:variable name="sum" select="fn:sum(Illustratie/number(@breedte))"/>
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
        <xsl:when test="(./@tekstomloop='ja')">
          <xsl:choose>
            <xsl:when test="./@uitlijning=('links','rechts')">
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
    <img class="figuur" src="{concat('media/',./@naam)}" width="{concat(my:value-to-pt(./@breedte),'px')}" alt="{./@alt}"/>
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