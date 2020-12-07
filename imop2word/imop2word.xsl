<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:my="http://mijn.eigen.ns" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture">
  <xsl:output method="text" version="1.0"/>

  <xsl:param name="base.dir" select="fn:substring-before(fn:base-uri(),'template.xml')"/>
  <xsl:param name="opdracht.dir" select="concat($base.dir,'/opdracht')"/>
  <xsl:param name="template.dir" select="concat($base.dir,'/temp/unzip')"/>
  <xsl:param name="word.dir" select="concat($template.dir,'/word')"/>
  <xsl:param name="props.dir" select="concat($template.dir,'/docProps')"/>

  <!-- namespaces -->
  <xsl:param name="data" select="string('https://standaarden.overheid.nl/stop/imop/data/')"/>
  <xsl:param name="eigen" select="string('https://www.eigen.nl/')"/>
  <xsl:param name="lvbb" select="string('https://standaarden.overheid.nl/lvbb/stop/aanlevering/')"/>
  <xsl:param name="tekst" select="string('https://standaarden.overheid.nl/stop/imop/tekst/')"/>

  <!-- verwijzingen naar gebruikte documenten -->
  <xsl:param name="document" select="concat($word.dir,'/document.xml')"/>
  <xsl:param name="core" select="document(concat($props.dir,'/core.xml'))"/>
  <xsl:param name="comments" select="concat($word.dir,'/comments.xml')"/>
  <xsl:param name="numbering" select="concat($word.dir,'/numbering.xml')"/>
  <xsl:param name="relations" select="document(concat($word.dir,'/_rels/document.xml.rels'))/Relationships" xpath-default-namespace="http://schemas.openxmlformats.org/package/2006/relationships"/>
  <xsl:param name="settings" select="concat($word.dir,'/settings.xml')"/>
  <xsl:param name="styles" select="document(concat($word.dir,'/styles.xml'))//w:style"/>
  <xsl:param name="footnotes" select="document(concat($word.dir,'/footnotes.xml'))/w:footnotes"/>

  <!-- bouw het document op -->

  <xsl:param name="consolidatie" select="collection(concat($opdracht.dir,'?select=*.xml'))//Consolidatie" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/uitlevering/"/>

  <xsl:template match="/">
    <!-- maak core.xml -->
    <xsl:result-document href="{concat($props.dir,'/core.xml')}" method="xml" indent="false">
      <xsl:apply-templates select="$core" mode="copy"/>
    </xsl:result-document>
    <!-- maak document.xml -->
    <xsl:result-document href="{concat($word.dir,'/document.xml')}" method="xml" indent="false">
      <xsl:element name="w:document">
        <xsl:copy-of select="w:document/(@*|namespace::*)"/>
        <xsl:element name="w:body">
          <xsl:apply-templates select="$consolidatie//RegelingCompact" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
          <!-- plaats sectie-instelling -->
          <xsl:call-template name="w:sectPr"/>
        </xsl:element>
      </xsl:element>
    </xsl:result-document>
    <!-- maak footnotes.xml -->
    <xsl:result-document href="{concat($word.dir,'/footnotes.xml')}" method="xml" indent="false">
      <xsl:element name="w:footnotes">
        <xsl:copy-of select="$footnotes/(@*|namespace::*)"/>
        <xsl:copy-of select="$footnotes/w:footnote"/>
        <xsl:for-each select="$consolidatie//RegelingCompact//Noot" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
          <xsl:element name="w:footnote">
            <xsl:attribute name="w:id" select="./NootNummer"/>
            <xsl:apply-templates select="node()"/>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:result-document>
    <!-- maak relations.xml -->
    <xsl:result-document href="{concat($word.dir,'/_rels/document.xml.rels')}" method="xml" indent="false">
      <xsl:element name="Relationships" namespace="http://schemas.openxmlformats.org/package/2006/relationships">
        <xsl:copy-of select="$relations/node()"/>
        <xsl:for-each select="$consolidatie//RegelingCompact//ExtRef" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
          <xsl:element name="Relationship" namespace="http://schemas.openxmlformats.org/package/2006/relationships">
            <xsl:attribute name="Id" select="generate-id(.)"/>
            <xsl:attribute name="Type" select="string('http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink')"/>
            <xsl:attribute name="Target" select="./@ref"/>
            <xsl:attribute name="TargetMode" select="string('External')"/>
          </xsl:element>
        </xsl:for-each>
        <xsl:for-each select="$consolidatie//RegelingCompact//Illustratie" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
          <xsl:element name="Relationship" namespace="http://schemas.openxmlformats.org/package/2006/relationships">
            <xsl:attribute name="Id" select="generate-id(.)"/>
            <xsl:attribute name="Type" select="string('http://schemas.openxmlformats.org/officeDocument/2006/relationships/image')"/>
            <xsl:attribute name="Target" select="fn:string-join(('media',./@naam),'/')"/>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:result-document>
  </xsl:template>

  <!-- alinea -->

  <xsl:template match="RegelingOpschrift/Al" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:element name="w:p">
      <xsl:element name="w:pPr">
        <xsl:element name="w:pStyle">
          <xsl:attribute name="w:val" select="($styles/self::w:style)[@w:type='paragraph'][@w:type='paragraph'][w:name/@w:val='Title']/@w:styleId"/>
        </xsl:element>
      </xsl:element>
      <xsl:element name="w:r">
        <xsl:element name="w:fldChar">
          <xsl:attribute name="w:fldCharType" select="string('begin')"/>
        </xsl:element>
      </xsl:element>
      <xsl:element name="w:r">
        <xsl:element name="w:instrText">
          <xsl:attribute name="xml:space" select="string('preserve')"/>
          <xsl:text> TITLE </xsl:text>
        </xsl:element>
      </xsl:element>
      <xsl:element name="w:r">
        <xsl:element name="w:fldChar">
          <xsl:attribute name="w:fldCharType" select="string('separate')"/>
        </xsl:element>
      </xsl:element>
      <xsl:apply-templates/>
      <xsl:element name="w:r">
        <xsl:element name="w:fldChar">
          <xsl:attribute name="w:fldCharType" select="string('end')"/>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dc:title" mode="copy">
    <xsl:element name="{name()}">
      <xsl:value-of select="($consolidatie//RegelingMetadata//(citeertitel,officieleTitel))[1]" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Lichaam//Kop[normalize-space(.) ne '']" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:variable name="parent" select="fn:index-of(('Hoofdstuk','Afdeling','Paragraaf','Subparagraaf','Subsubparagraaf','Artikel'),parent::element()/name())"/>
    <xsl:variable name="style" select="('heading 1','heading 2','heading 3','heading 4','heading 5','heading 6')"/>
    <xsl:element name="w:p">
      <xsl:element name="w:pPr">
        <xsl:element name="w:pStyle">
          <xsl:attribute name="w:val" select="($styles/self::w:style)[@w:type='paragraph'][w:name/@w:val=$style[$parent]]/@w:styleId"/>
        </xsl:element>
      </xsl:element>
      <xsl:element name="w:r">
        <xsl:element name="w:t">
          <xsl:value-of select="fn:string-join((Label,Nummer),' ')"/>
        </xsl:element>
      </xsl:element>
      <xsl:element name="w:r">
        <xsl:element name="w:tab"/>
      </xsl:element>
      <xsl:apply-templates select="Opschrift"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="(Bijlage|Toelichting)//Kop[normalize-space(.) ne '']" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:variable name="level" select="count(ancestor::element()[name()=('Bijlage','Toelichting','InleidendeTekst','Divisie','Divisietekst')])"/>
    <xsl:variable name="style" select="fn:string-join(('Divisie','kop',$level),' ')"/>
    <xsl:element name="w:p">
      <xsl:element name="w:pPr">
        <xsl:element name="w:pStyle">
          <xsl:attribute name="w:val" select="($styles/self::w:style)[@w:type='paragraph'][w:name/@w:val=$style]/@w:styleId"/>
        </xsl:element>
      </xsl:element>
      <xsl:element name="w:r">
        <xsl:element name="w:t">
          <xsl:value-of select="fn:string-join((Label,Nummer),' ')"/>
        </xsl:element>
      </xsl:element>
      <xsl:element name="w:r">
        <xsl:element name="w:tab"/>
      </xsl:element>
      <xsl:apply-templates select="Opschrift"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="title" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:element name="w:p">
      <xsl:element name="w:pPr">
        <xsl:element name="w:pStyle">
          <xsl:attribute name="w:val" select="($styles/self::w:style)[@w:type='paragraph'][w:name/@w:val='Tabeltitel']/@w:styleId"/>
        </xsl:element>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="LidNummer" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <!-- wordt gedaan door Lid//Al[1] -->
  </xsl:template>

  <xsl:template match="Lid/Inhoud/(Al|Lijst/Lijstaanhef)[1]" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:element name="w:p">
      <xsl:element name="w:pPr">
        <xsl:element name="w:pStyle">
          <xsl:attribute name="w:val" select="($styles/self::w:style)[@w:type='paragraph'][w:name/@w:val='Lid met nummering']/@w:styleId"/>
        </xsl:element>
      </xsl:element>
      <xsl:element name="w:r">
        <xsl:element name="w:t">
          <xsl:value-of select="ancestor::Lid/LidNummer"/>
        </xsl:element>
      </xsl:element>
      <xsl:element name="w:r">
        <xsl:element name="w:tab"/>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="LiNummer" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <!-- wordt gedaan door Li/Al[1] -->
  </xsl:template>

  <xsl:template match="Li/(Al|Lijst/Lijstaanhef)[1]" priority="1" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:element name="w:p">
      <xsl:element name="w:pPr">
        <xsl:element name="w:pStyle">
          <xsl:attribute name="w:val" select="($styles/self::w:style)[@w:type='paragraph'][w:name/@w:val='Opsomming met nummering']/@w:styleId"/>
        </xsl:element>
        <xsl:element name="w:ind">
          <xsl:attribute name="w:left" select="count(ancestor::Li)*425"/>
        </xsl:element>
      </xsl:element>
      <xsl:element name="w:r">
        <xsl:element name="w:t">
          <xsl:value-of select="(ancestor::Li/LiNummer)[last()]"/>
        </xsl:element>
      </xsl:element>
      <xsl:element name="w:r">
        <xsl:element name="w:tab"/>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Li/Al" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:element name="w:p">
      <xsl:element name="w:pPr">
        <xsl:element name="w:pStyle">
          <xsl:attribute name="w:val" select="($styles/self::w:style)[@w:type='paragraph'][w:name/@w:val='Opsomming']/@w:styleId"/>
        </xsl:element>
        <xsl:element name="w:ind">
          <xsl:attribute name="w:left" select="count(ancestor::Li)*425"/>
        </xsl:element>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Al" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:element name="w:p">
      <xsl:apply-templates/>
    </xsl:element>
    <xsl:if test="not(ancestor::Groep) and following-sibling::element()[1][name()='Al']">
      <xsl:element name="w:p"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="Lijstaanhef" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:element name="w:p">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Noot/Al[1]" priority="1" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:element name="w:p">
      <xsl:element name="w:pPr">
        <xsl:element name="w:pStyle">
          <xsl:attribute name="w:val" select="($styles/self::w:style)[@w:type='paragraph'][w:name/@w:val='footnote text']/@w:styleId"/>
        </xsl:element>
      </xsl:element>
      <xsl:element name="w:r">
        <xsl:element name="w:rPr">
          <xsl:element name="w:rStyle">
            <xsl:attribute name="w:val" select="($styles/self::w:style)[@w:type='character'][w:name/@w:val='footnote reference']/@w:styleId"/>
          </xsl:element>
        </xsl:element>
        <xsl:element name="w:t">
          <xsl:value-of select="ancestor::Noot/NootNummer"/>
        </xsl:element>
      </xsl:element>
      <xsl:element name="w:r">
        <xsl:element name="w:tab"/>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Noot/Al" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:element name="w:p">
      <xsl:element name="w:pPr">
        <xsl:element name="w:pStyle">
          <xsl:attribute name="w:val" select="($styles/self::w:style)[@w:type='paragraph'][w:name/@w:val='footnote text']/@w:styleId"/>
        </xsl:element>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Term" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <!-- hier mogelijk nog onderscheid maken met begrippen t.b.v. GIO's -->
    <xsl:element name="w:p">
      <xsl:element name="w:pPr">
        <xsl:element name="w:pStyle">
          <xsl:attribute name="w:val" select="($styles/self::w:style)[@w:type='paragraph'][w:name/@w:val='Begrip']/@w:styleId"/>
        </xsl:element>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Tussenkop" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:element name="w:p">
      <xsl:element name="w:pPr">
        <xsl:element name="w:pStyle">
          <xsl:attribute name="w:val" select="($styles/self::w:style)[@w:type='paragraph'][w:name/@w:val='Alineakop']/@w:styleId"/>
        </xsl:element>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- range -->

  <xsl:template match="b" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:element name="w:r">
      <xsl:element name="w:rPr">
        <xsl:element name="w:b"/>
        <xsl:element name="w:bCs"/>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="i" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:element name="w:r">
      <xsl:element name="w:rPr">
        <xsl:element name="w:i"/>
        <xsl:element name="w:iCs"/>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="u" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:element name="w:r">
      <xsl:element name="w:rPr">
        <xsl:element name="w:u">
          <xsl:attribute name="w:val" select="string('single')"/>
        </xsl:element>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="sub" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:element name="w:r">
      <xsl:element name="w:rPr">
        <xsl:element name="w:vertAlign">
          <xsl:attribute name="w:val" select="string('subscript')"/>
        </xsl:element>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="sup" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:element name="w:r">
      <xsl:element name="w:rPr">
        <xsl:element name="w:vertAlign">
          <xsl:attribute name="w:val" select="string('superscript')"/>
        </xsl:element>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Noot" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:element name="w:r">
      <xsl:element name="w:rPr">
        <xsl:element name="w:rStyle">
          <xsl:attribute name="w:val" select="($styles/self::w:style)[@w:type='character'][w:name/@w:val='footnote reference']/@w:styleId"/>
        </xsl:element>
      </xsl:element>
      <xsl:element name="w:footnoteReference">
        <xsl:attribute name="w:id" select="./NootNummer"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>  

  <xsl:template match="NootNummer" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <!-- doe niets -->
  </xsl:template>

  <xsl:template match="ExtRef" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:element name="w:hyperlink">
      <xsl:attribute name="r:id" select="generate-id(.)"/>
      <xsl:element name="w:r">
        <xsl:element name="w:rPr">
          <xsl:element name="w:rStyle">
            <xsl:attribute name="w:val" select="($styles/self::w:style)[@w:type='character'][w:name/@w:val='Hyperlink']/@w:styleId"/>
          </xsl:element>
        </xsl:element>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="(Al|Bijschrift|Lijstaanhef|Opschrift|Term|title|Tussenkop)/text()" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:element name="w:r">
      <xsl:call-template name="w:t"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:call-template name="w:t"/>
  </xsl:template>

  <xsl:template name="w:t">
    <xsl:choose>
      <xsl:when test="(normalize-space(.)='') and contains(.,'&#10;')">
        <!-- lege tekst met een zachte return is indentation -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="w:t">
          <xsl:variable name="myText">
            <xsl:value-of select="fn:string-join(fn:tokenize(.,'\s+'),' ')"/>
          </xsl:variable>
          <xsl:if test="starts-with($myText,' ') or ends-with($myText,' ')">
            <xsl:attribute name="xml:space" select="string('preserve')"/>
          </xsl:if>
          <xsl:value-of select="$myText"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- figuur -->

  <xsl:template match="Figuur" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:element name="w:p">
      <xsl:element name="w:pPr">
        <xsl:element name="w:pStyle">
          <xsl:attribute name="w:val" select="($styles/self::w:style)[@w:type='paragraph'][w:name/@w:val='Figuur']/@w:styleId"/>
        </xsl:element>
      </xsl:element>
      <xsl:apply-templates select="Illustratie"/>
    </xsl:element>
    <xsl:apply-templates select="Bijschrift"/>
  </xsl:template>

  <xsl:template match="Illustratie" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:variable name="index" select="count(.|preceding::Illustratie)" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>
    <!-- zet de breedte naar de volle breedte van de tekstkolom en de hoogte in dezelfde verhouding -->
    <xsl:variable name="verhouding" select="5040000 div ./@breedte"/>
    <xsl:element name="w:r">
      <xsl:element name="w:rPr">
        <xsl:element name="w:noProof"/>
      </xsl:element>
    </xsl:element>
    <xsl:element name="w:drawing">
      <xsl:element name="wp:inline">
        <xsl:element name="wp:extent">
          <xsl:attribute name="cx" select="format-number(./@breedte*$verhouding,'0')"/>
          <xsl:attribute name="cy" select="format-number(./@hoogte*$verhouding,'0')"/>
        </xsl:element>
        <xsl:element name="wp:effectExtent"/>
        <xsl:element name="wp:docPr">
          <xsl:attribute name="id" select="$index"/>
          <xsl:attribute name="name" select="concat('Afbeelding ',$index)"/>
          <xsl:attribute name="descr" select="concat('Afbeelding ',$index)"/>
        </xsl:element>
        <xsl:element name="a:graphic">
          <xsl:element name="a:graphicData">
            <xsl:attribute name="uri" select="string('http://schemas.openxmlformats.org/drawingml/2006/picture')"/>
            <xsl:element name="pic:pic">
              <xsl:element name="pic:nvPicPr">
                <xsl:element name="pic:cNvPr">
                  <xsl:attribute name="id" select="$index"/>
                  <xsl:attribute name="name" select="concat('Afbeelding ',$index)"/>
                  <xsl:attribute name="descr" select="concat('Afbeelding ',$index)"/>
                </xsl:element>
                <xsl:element name="pic:cNvPicPr"/>
              </xsl:element>
              <xsl:element name="pic:blipFill">
                <xsl:element name="a:blip">
                  <xsl:attribute name="r:embed" select="generate-id(.)"/>
                  <xsl:attribute name="cstate" select="string('print')"/>
                </xsl:element>
                <xsl:element name="a:srcRect"/>
                <xsl:element name="a:stretch"/>
              </xsl:element>
              <xsl:element name="pic:spPr">
                <xsl:element name="a:xfrm">
                  <xsl:element name="a:off">
                    <xsl:attribute name="x" select="0"/>
                    <xsl:attribute name="y" select="0"/>
                  </xsl:element>
                  <xsl:element name="a:ext">
                    <xsl:attribute name="cx" select="format-number(./@breedte*$verhouding,'0')"/>
                    <xsl:attribute name="cy" select="format-number(./@hoogte*$verhouding,'0')"/>
                  </xsl:element>
                </xsl:element>
                <xsl:element name="a:prstGeom">
                  <xsl:attribute name="prst" select="string('rect')"/>
                  <xsl:element name="a:avLst"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="Bijschrift" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:element name="w:p">
      <xsl:element name="w:pPr">
        <xsl:element name="w:pStyle">
          <xsl:attribute name="w:val" select="($styles/self::w:style)[@w:type='paragraph'][w:name/@w:val='Figuurbijschrift']/@w:styleId"/>
        </xsl:element>
      </xsl:element>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- tabel -->

  <xsl:template match="table" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:variable name="cols">
      <xsl:for-each select="./tgroup/colspec">
        <xsl:element name="col">
          <xsl:attribute name="num" select="./@colnum"/>
          <xsl:attribute name="name" select="./@colname"/>
          <xsl:attribute name="width" select="replace(./@colwidth,'\*','')"/>
        </xsl:element>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="sum">
      <xsl:value-of select="sum($cols/col/@width)" xpath-default-namespace=""/>
    </xsl:variable>
    <xsl:apply-templates select="./title"/>
    <xsl:element name="w:tbl">
      <xsl:element name="w:tblPr">
        <xsl:element name="w:tblStyle">
          <xsl:attribute name="w:val" select="($styles/self::w:style)[@w:type='table'][w:name/@w:val='Tabel']/@w:styleId"/>
        </xsl:element>
        <xsl:element name="w:tblLayout">
          <xsl:attribute name="w:type" select="string('fixed')"/>
        </xsl:element>
      </xsl:element>
      <xsl:for-each select="$cols/col" xpath-default-namespace="">
        <xsl:element name="w:gridCol">
          <xsl:attribute name="w:w" select="round(./@width div $sum * my:value-to-twip('140mm'))"/>
        </xsl:element>
      </xsl:for-each>
      <xsl:for-each select="./tgroup/(thead|tbody)/row">
        <xsl:variable name="row" select="."/>
        <xsl:element name="w:tr">
          <xsl:element name="w:trPr">
            <xsl:element name="w:cantSplit"/>
            <xsl:if test="./parent::thead">
              <xsl:element name="w:tblHeader"/>
            </xsl:if>
          </xsl:element>
          <xsl:for-each select="$row/entry" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
            <xsl:variable name="cell" select="."/>
            <!-- span -->
            <xsl:variable name="colspan" select="number($cols/col[@name=$cell/@nameend]/@num)-number($cols/col[@name=$cell/@namest]/@num)" xpath-default-namespace=""/>
            <xsl:variable name="cell_index" select="number(($cols/col[@name=$cell/@colname]/@num,position())[1])" xpath-default-namespace=""/>
            <xsl:variable name="test_index" select="number(($cols/col[@name=$cell/preceding-sibling::element()[1]/@colname]/@num,count(preceding-sibling::element()))[1])+1" xpath-default-namespace=""/>
            <xsl:if test="$cell_index ne $test_index">
              <xsl:element name="w:tc">
                <xsl:element name="w:tcPr">
                  <xsl:element name="w:vMerge"/>
                </xsl:element>
                <xsl:element name="w:p"/>
              </xsl:element>
            </xsl:if>
            <xsl:element name="w:tc">
              <xsl:if test="$colspan gt 0">
                <xsl:element name="w:tcPr">
                  <xsl:element name="w:gridSpan">
                    <xsl:attribute name="w:val" select="$colspan+1"/>
                  </xsl:element>
                </xsl:element>
              </xsl:if>
              <xsl:if test="number($cell/@morerows) gt 0">
                <xsl:element name="w:tcPr">
                  <xsl:element name="w:vMerge">
                    <xsl:attribute name="w:val" select="string('restart')"/>
                  </xsl:element>
                </xsl:element>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="$cell/node()">
                  <xsl:apply-templates select="$cell/node()"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:element name="w:p"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
    <xsl:element name="w:p"/>
  </xsl:template>

  <!-- algemene templates -->

  <xsl:template match="element()" mode="copy">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:apply-templates select="@*|namespace::*"/>
      <xsl:apply-templates select="node()" mode="copy"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="element()">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:copy-of select="."/>
  </xsl:template>
  
  <xsl:template match="namespace::*">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()">
    <xsl:copy-of select="."/>
  </xsl:template>

  <!-- extra routines -->

  <xsl:template name="w:sectPr">
    <xsl:element name="w:sectPr">
      <xsl:element name="w:headerReference">
        <xsl:attribute name="w:type" select="string('even')"/>
        <xsl:attribute name="r:id" select="string('rId7')"/>
      </xsl:element>
      <xsl:element name="w:headerReference">
        <xsl:attribute name="w:type" select="string('default')"/>
        <xsl:attribute name="r:id" select="string('rId8')"/>
      </xsl:element>
      <xsl:element name="w:footerReference">
        <xsl:attribute name="w:type" select="string('even')"/>
        <xsl:attribute name="r:id" select="string('rId9')"/>
      </xsl:element>
      <xsl:element name="w:footerReference">
        <xsl:attribute name="w:type" select="string('default')"/>
        <xsl:attribute name="r:id" select="string('rId10')"/>
      </xsl:element>
      <xsl:element name="w:headerReference">
        <xsl:attribute name="w:type" select="string('first')"/>
        <xsl:attribute name="r:id" select="string('rId11')"/>
      </xsl:element>
      <xsl:element name="w:footerReference">
        <xsl:attribute name="w:type" select="string('first')"/>
        <xsl:attribute name="r:id" select="string('rId12')"/>
      </xsl:element>
      <xsl:element name="w:pgSz">
        <xsl:attribute name="w:w" select="my:value-to-twip('210mm')"/>
        <xsl:attribute name="w:h" select="my:value-to-twip('297mm')"/>
        <xsl:attribute name="w:code" select="string('9')"/>
      </xsl:element>
      <xsl:element name="w:pgMar">
        <xsl:attribute name="w:top" select="my:value-to-twip('20mm')"/>
        <xsl:attribute name="w:right" select="my:value-to-twip('20mm')"/>
        <xsl:attribute name="w:bottom" select="my:value-to-twip('20mm')"/>
        <xsl:attribute name="w:left" select="my:value-to-twip('50mm')"/>
        <xsl:attribute name="w:header" select="my:value-to-twip('10mm')"/>
        <xsl:attribute name="w:footer" select="my:value-to-twip('10mm')"/>
        <xsl:attribute name="w:gutter" select="my:value-to-twip('0mm')"/>
      </xsl:element>
      <xsl:element name="w:cols">
        <xsl:attribute name="w:space" select="my:value-to-twip('12.5mm')"/>
      </xsl:element>
      <xsl:element name="w:docGrid">
        <xsl:attribute name="w:linePitch" select="my:value-to-twip('5mm')"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- functies -->

  <xsl:function name="my:value-to-twip" as="xs:decimal">
    <xsl:param name="value"/>
    <xsl:variable name="units" select="('cm','in','mm','pt','px')"/>
    <xsl:variable name="values" select="(566.925563,1440.092166,56.6925563,19.999887,15)"/>
    <xsl:variable name="unit" select="$units[contains($value,.)]"/>
    <xsl:value-of select="round(number(fn:tokenize($value,$unit)[1]) * $values[fn:index-of($units,$unit)])"/>
  </xsl:function>

</xsl:stylesheet>