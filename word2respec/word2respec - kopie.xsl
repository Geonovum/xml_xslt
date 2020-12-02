<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:wx="http://schemas.microsoft.com/office/word/2006/auxHint" xmlns:ve="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture" xmlns:dc="http://purl.org/dc/elements/1.1/">
  <xsl:output method="xhtml" encoding="UTF-8" indent="no" omit-xml-declaration="yes" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

  <xsl:param name="base.dir" select="string('C:\Werkbestanden\Geonovum\word2respec')"/>
  <xsl:param name="unzip.dir" select="fn:string-join((fn:tokenize($base.dir,'\\'),'unzip'),$delimiter)"/>

  <!-- scheidingsteken in paden -->
  <xsl:param name="delimiter" select="string('/')"/>

  <!-- verwijzingen naar gebruikte documenten -->
  <xsl:param name="comments" select="fn:string-join(('file:',$unzip.dir,'word','comments.xml'),$delimiter)"/>
  <xsl:param name="endnotes" select="fn:string-join(('file:',$unzip.dir,'word','endnotes.xml'),$delimiter)"/>
  <xsl:param name="footnotes" select="fn:string-join(('file:',$unzip.dir,'word','footnotes.xml'),$delimiter)"/>
  <xsl:param name="numbering" select="fn:string-join(('file:',$unzip.dir,'word','numbering.xml'),$delimiter)"/>
  <xsl:param name="relations" select="fn:string-join(('file:',$unzip.dir,'word','_rels','document.xml.rels'),$delimiter)"/>
  <xsl:param name="settings" select="fn:string-join(('file:',$unzip.dir,'word','settings.xml'),$delimiter)"/>
  <xsl:param name="styles" select="fn:string-join(('file:',$unzip.dir,'word','styles.xml'),$delimiter)"/>
  <xsl:param name="props" select="fn:string-join(('file:',$unzip.dir,'docProps','core.xml'),$delimiter)"/>

  <!-- title -->

  <xsl:param name="title" select="$TOC/title"/>
  <xsl:param name="list_word" select="('bullet','decimal','upper-roman','lower-roman','upper-letter','lower-letter')"/>
  <xsl:param name="list_html" select="('ul','ol','ol','ol','ol','ol')"/>

  <!-- maak de inhoudsopgave -->

  <xsl:param name="tree">
    <xsl:element name="body">
      <xsl:attribute name="id" select="generate-id(//w:body/element()[1])"/>
      <xsl:attribute name="level" select="0"/>
      <xsl:element name="title">
        <xsl:value-of select="document($props,.)//dc:title"/>
      </xsl:element>
      <xsl:call-template name="tree">
        <xsl:with-param name="group" select="//w:body/w:p"/>
        <xsl:with-param name="level" select="1"/>
      </xsl:call-template>
    </xsl:element>
  </xsl:param>

  <xsl:template name="tree">
    <xsl:param name="group"/>
    <xsl:param name="level"/>
    <xsl:variable name="styleId" select="document($styles,.)//w:style[w:name/@w:val=fn:format-number($level,'heading #')]/@w:styleId"/>
    <xsl:for-each-group select="$group" group-starting-with="w:p[w:pPr/w:pStyle/@w:val=$styleId]">
      <xsl:choose>
        <xsl:when test="current-group()[1][w:pPr/w:pStyle/@w:val=$styleId]">
          <xsl:element name="section">
            <xsl:attribute name="id" select="generate-id(.)"/>
            <xsl:attribute name="level" select="$level"/>
            <xsl:element name="heading">
              <xsl:copy-of select="node()"/>
            </xsl:element>
            <xsl:call-template name="tree">
              <xsl:with-param name="group" select="subsequence(current-group(),2)"/>
              <xsl:with-param name="level" select="$level+1"/>
            </xsl:call-template>
          </xsl:element>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>

  <xsl:variable name="TOC">
    <xsl:for-each select="$tree//title">
      <xsl:element name="title">
        <xsl:attribute name="id" select="parent::body/@id"/>
        <xsl:attribute name="level" select="parent::body/@level+1"/>
        <xsl:element name="text">
          <xsl:copy-of select="node()"/>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
    <xsl:for-each select="$tree//heading">
      <xsl:element name="heading">
        <xsl:attribute name="id" select="parent::section/@id"/>
        <xsl:attribute name="level" select="parent::section/@level+1"/>
        <xsl:element name="number">
          <xsl:for-each select="ancestor::section">
            <item><xsl:value-of select="count(.|preceding-sibling::section[heading])"/></item>
          </xsl:for-each>
        </xsl:element>
        <xsl:element name="text">
          <xsl:copy-of select="node()"/>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
  </xsl:variable>

  <!-- algemeen -->

  <xsl:template match="element()">
    <xsl:param name="id"/>
    <xsl:apply-templates>
      <xsl:with-param name="id" select="$id"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:copy/>
  </xsl:template>

  <!-- document -->

  <xsl:template match="w:document">
    <xsl:element name="html">
      <xsl:attribute name="lang" select="string('en')"/>
      <xsl:attribute name="dir" select="string('ltr')"/>
      <xsl:element name="head">
        <xsl:element name="meta">
          <xsl:attribute name="charset" select="string('utf-8')"/>
        </xsl:element>
        <xsl:element name="meta">
          <xsl:attribute name="name" select="string('generator')"/>
          <xsl:attribute name="content" select="string('ReSpec 24.5.2')"/>
        </xsl:element>
        <xsl:element name="meta">
          <xsl:attribute name="name" select="string('viewport')"/>
          <xsl:attribute name="content" select="string('width=device-width, initial-scale=1, shrink-to-fit=no')"/>
        </xsl:element>
        <xsl:element name="link">
          <xsl:attribute name="rel" select="string('shortcut icon')"/>
          <xsl:attribute name="type" select="string('image/x-icon')"/>
          <xsl:attribute name="href" select="string('https://tools.geostandaarden.nl/respec/style/logos/Geonovum.ico')"/>
        </xsl:element>
        <xsl:element name="link">
          <xsl:attribute name="rel" select="string('stylesheet')"/>
          <xsl:attribute name="type" select="string('text/css')"/>
          <xsl:attribute name="href" select="string('https://tools.geostandaarden.nl/respec/style/base.css')"/>
        </xsl:element>
        <xsl:element name="link">
          <xsl:attribute name="rel" select="string('stylesheet')"/>
          <xsl:attribute name="type" select="string('text/css')"/>
          <xsl:attribute name="href" select="string('https://tools.geostandaarden.nl/respec/style/GN-DEF.css')"/>
        </xsl:element>
        <xsl:element name="title">
          <xsl:value-of select="$title/text"/>
        </xsl:element>
      </xsl:element>
      <xsl:apply-templates select="w:body"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="w:body">
    <xsl:element name="body">
      <xsl:attribute name="cz-shortcut-listen" select="string('true')"/>
      <xsl:attribute name="class" select="string('h-entry')"/>
      <!-- plaats titel -->
      <xsl:element name="h1">
        <xsl:attribute name="id" select="string('title')"/>
        <xsl:attribute name="class" select="string('title p-name')"/>
        <xsl:value-of select="$title/text"/>
      </xsl:element>
      <!-- plaats navigator -->
      <xsl:element name="nav">
        <xsl:attribute name="id" select="string('toc')"/>
        <xsl:element name="h2">
          <xsl:attribute name="id" select="string('table-of-contents')"/>
          <xsl:attribute name="class" select="string('introductory')"/>
          <xsl:value-of select="string('Table of Contents')"/>
        </xsl:element>
        <xsl:call-template name="nav">
          <xsl:with-param name="group" select="$tree/body"/>
        </xsl:call-template>
      </xsl:element>
      <!-- plaats inhoud -->
      <xsl:call-template name="section">
        <xsl:with-param name="group" select="node()"/>
        <xsl:with-param name="level" select="1"/>
      </xsl:call-template>
    </xsl:element>
  </xsl:template>

  <!-- navigatie -->
  <xsl:template name="nav">
    <xsl:param name="group"/>
    <xsl:if test="$group/section">
      <xsl:element name="ol">
        <xsl:attribute name="class" select="string('toc')"/>
        <xsl:for-each select="$group/section">
          <xsl:variable name="id" select="@id"/>
          <xsl:element name="li">
            <xsl:attribute name="class" select="string('tocline')"/>
            <xsl:for-each select="heading">
              <xsl:element name="a">
                <xsl:attribute name="class" select="string('tocxref')"/>
                <xsl:attribute name="href" select="concat('#',$id)"/>
                <xsl:element name="span">
                  <xsl:attribute name="class" select="string('secno')"/>
                  <xsl:value-of select="concat(fn:string-join($TOC/heading[@id eq $id]/number/item,'.'),' ')"/>
                </xsl:element>
                <xsl:apply-templates select="."/>
              </xsl:element>
            </xsl:for-each>
            <xsl:call-template name="nav">
              <xsl:with-param name="group" select="."/>
            </xsl:call-template>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <!-- groepeer elementen hiërarchisch -->

  <xsl:template name="section">
    <xsl:param name="group"/>
    <xsl:param name="level"/>
    <xsl:variable name="styleId" select="document($styles,.)//w:style[w:name/@w:val=fn:format-number($level,'heading #')]/@w:styleId"/>
    <xsl:for-each-group select="$group" group-starting-with="w:p[w:pPr/w:pStyle/@w:val=$styleId]">
      <xsl:variable name="id" select="generate-id(.)"/>
      <xsl:choose>
        <xsl:when test="current-group()[1][w:pPr/w:pStyle/@w:val=$styleId]">
          <xsl:element name="section">
            <xsl:attribute name="id" select="$id"/>
            <xsl:apply-templates select="current-group()[1]">
              <xsl:with-param name="id" select="$id"/>
            </xsl:apply-templates>
            <xsl:call-template name="section">
              <xsl:with-param name="group" select="subsequence(current-group(),2)"/>
              <xsl:with-param name="level" select="$level+1"/>
            </xsl:call-template>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="group_adjacent">
            <xsl:with-param name="group" select="current-group()"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>

  <!-- groepeer elementen niet-hiërarchisch -->

  <xsl:template name="group_adjacent">
    <xsl:param name="group"/>
    <xsl:variable name="styleId" select="document($styles,.)//w:style[w:name/@w:val='caption']/@w:styleId"/>
    <xsl:for-each-group select="$group" group-adjacent="if (self::w:p[w:r/w:drawing]|self::w:p[w:pPr/w:pStyle/@w:val=$styleId][preceding-sibling::w:p[1][w:r/w:drawing]]) then 'figuur' else if (self::w:tbl|self::w:p[w:pPr/w:pStyle/@w:val=$styleId][following-sibling::element()[1][w:tbl]]) then 'tabel' else if (self::w:p[w:pPr/w:numPr]) then 'lijst' else if (self::w:p[w:r/w:rPr/w:highlight/@w:val]) then fn:distinct-values(self::w:p/w:r/w:rPr/w:highlight/@w:val) else if (self::w:p[w:sdt/w:sdtPr/w14:checkbox]) then 'check' else 'standaard'">
      <xsl:choose>
        <xsl:when test="current-grouping-key()='figuur'">
          <xsl:for-each-group select="current-group()" group-ending-with="self::w:p[contains(w:pPr/w:pStyle/@w:val,'Bijschrift')]">
            <xsl:element name="figure">
              <xsl:attribute name="id" select="generate-id(.)"/>
              <xsl:for-each select="current-group()">
                <xsl:choose>
                  <xsl:when test="self::w:p[w:r/w:drawing]">
                    <xsl:apply-templates select="./w:r/w:drawing"/>
                  </xsl:when>
                  <xsl:when test="self::w:p[w:pPr/w:pStyle/@w:val=$styleId]">
                    <xsl:element name="figcaption">
                      <xsl:apply-templates select="node()"/>
                    </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:apply-templates select="."/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:element>
          </xsl:for-each-group>
        </xsl:when>
        <xsl:when test="current-grouping-key()='tabel'">
          <xsl:apply-templates select="current-group()"/>
        </xsl:when>
        <xsl:when test="current-grouping-key()='lijst'">
          <xsl:for-each-group select="current-group()" group-by="w:pPr/w:numPr/w:numId/@w:val">
            <xsl:call-template name="lijst">
              <xsl:with-param name="group" select="current-group()"/>
              <xsl:with-param name="id" select="document($numbering,.)//w:num[@w:numId eq current-grouping-key()]/w:abstractNumId/@w:val"/>
            </xsl:call-template>
          </xsl:for-each-group>
        </xsl:when>
        <xsl:when test="current-grouping-key()='cyan'">
          <!-- highlight cyan wordt gebruikt om een code-blok aan te geven -->
          <xsl:element name="pre">
            <xsl:element name="code">
              <xsl:for-each select="current-group()/self::w:p">
                <xsl:apply-templates select="node()"/>
                <xsl:text>&#10;</xsl:text>
              </xsl:for-each>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="current-grouping-key()='check'">
          <xsl:element name="ul">
            <xsl:attribute name="class" select="string('contains-task-list')"/>
            <xsl:for-each select="current-group()/self::w:p">
              <xsl:element name="li">
                <xsl:attribute name="class" select="string('task-list-item')"/>
                <xsl:apply-templates select="node()"/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:when>
        <xsl:when test="current-grouping-key()='standaard'">
          <xsl:apply-templates select="current-group()">
            <xsl:with-param name="id" select="generate-id(.)"/>
          </xsl:apply-templates>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>

  <!-- groepeer element lijst -->

  <xsl:template name="lijst">
    <xsl:param name="group"/>
    <xsl:param name="id"/>
    <xsl:param name="level" select="0"/>
    <xsl:variable name="list" select="document($numbering,.)//w:abstractNum[@w:abstractNumId eq $id]"/>
    <xsl:variable name="type" select="($list_html[fn:index-of($list_word,$list/w:lvl[number(@w:ilvl) eq $level]/w:numFmt/@w:val)],'ul')[1]"/>
    <xsl:element name="{$type}">
      <xsl:for-each-group select="$group" group-starting-with="self::w:p[number(w:pPr/w:numPr/w:ilvl/@w:val) eq $level]">
        <xsl:element name="li">
          <!-- verwerk geneste opsommingen -->
          <xsl:for-each-group select="current-group()" group-adjacent="if (number(self::w:p/w:pPr/w:numPr/w:ilvl/@w:val) gt $level) then 'lijst' else 'item'">
            <xsl:choose>
              <xsl:when test="current-grouping-key() eq 'item'">
                <xsl:apply-templates select="current-group()[1]/self::w:p"/>
              </xsl:when>
              <xsl:when test="current-grouping-key() eq 'lijst'">
                <xsl:call-template name="lijst">
                  <xsl:with-param name="group" select="current-group()"/>
                  <xsl:with-param name="id" select="$id"/>
                  <xsl:with-param name="level" select="number(current-group()[1]/self::w:p/w:pPr/w:numPr/w:ilvl/@w:val)"/>
                </xsl:call-template>
              </xsl:when>
            </xsl:choose>
          </xsl:for-each-group>
        </xsl:element>
      </xsl:for-each-group>
    </xsl:element>
  </xsl:template>

  <!-- elementen -->

  <xsl:template match="w:p">
    <xsl:param name="id"/>
    <xsl:variable name="title" select="$TOC/title[@id eq $id]"/>
    <xsl:variable name="heading" select="$TOC/heading[@id eq $id]"/>
    <xsl:variable name="styleId" select="w:pPr/w:pStyle/@w:val"/>
    <xsl:variable name="style" select="document($styles,.)//w:style[@w:styleId=($styleId,'Standaard')[1]]/w:name/@w:val"/>
    <xsl:choose>
      <xsl:when test="$heading">
        <xsl:element name="{concat('h',$heading/@level)}">
          <xsl:attribute name="id" select="concat('x',fn:string-join(($heading/number/item,$id),'-'))"/>
          <xsl:element name="span">
            <xsl:attribute name="class" select="string('secno')"/>
            <xsl:value-of select="concat(fn:string-join($heading/number/item,'.'),' ')"/>
          </xsl:element>
          <xsl:apply-templates select="node()"/>
        </xsl:element>
      </xsl:when>
      <xsl:when test="$title">
        <!-- title wordt door w:body geplaatst -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="p">
          <xsl:apply-templates select="node()"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- hyperlink -->

  <xsl:template match="w:hyperlink">
    <xsl:variable name="id" select="@r:id"/>
    <xsl:variable name="relationship" select="document($relations,.)//Relationship[@Id=$id]" xpath-default-namespace="http://schemas.openxmlformats.org/package/2006/relationships"/>
    <xsl:choose>
      <xsl:when test="contains($relationship/@TargetMode,'External')">
        <xsl:element name="a">
          <xsl:attribute name="href" select="$relationship/@Target"/>
          <xsl:attribute name="target" select="string('_blank')"/>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- range bewerken -->

  <xsl:template match="w:r">
    <xsl:choose>
      <xsl:when test="w:rPr">
        <xsl:call-template name="range">
          <xsl:with-param name="node" select="."/>
          <xsl:with-param name="index" select="1"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="range">
    <xsl:param name="node"/>
    <xsl:param name="index"/>
    <xsl:variable name="styleId" select="('b','i','u','sup','sub')"/>
    <xsl:choose>
      <xsl:when test="$index gt count($styleId)">
        <xsl:apply-templates select="$node/node()"/>
      </xsl:when>
      <xsl:when test="$node/w:rPr[(*[local-name() eq $styleId[$index]]) or (w:vertAlign[starts-with(@w:val,$styleId[$index])])]">
        <xsl:element name="{$styleId[$index]}">
          <xsl:call-template name="range">
            <xsl:with-param name="node" select="$node"/>
            <xsl:with-param name="index" select="$index+1"/>
          </xsl:call-template>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="range">
          <xsl:with-param name="node" select="$node"/>
          <xsl:with-param name="index" select="$index+1"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="w:instrText">
    <!-- tekst niet plaatsen -->
  </xsl:template>

  <!-- tekens -->

  <xsl:template match="w:br">
    <xsl:element name="br"/>
  </xsl:template>

  <xsl:template match="w:tab">
    <xsl:text>    </xsl:text>
  </xsl:template>

  <xsl:template match="w14:checkbox">
    <xsl:element name="input">
      <xsl:attribute name="class" select="string('task-list-item-checkbox')"/>
      <xsl:attribute name="id" select="generate-id(.)"/>
      <xsl:attribute name="style" select="string('margin-right: 2mm;')"/>
      <xsl:attribute name="type" select="string('checkbox')"/>
      <xsl:if test="w14:checked/@w14:val=1">
        <xsl:attribute name="checked"/>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <xsl:template match="w:sdtContent">
    <!-- tekst niet plaatsen -->
  </xsl:template>

  <!-- tabel -->

  <xsl:template match="w:tbl">
    <xsl:variable name="cols" select="w:tblGrid/w:gridCol"/>
    <xsl:variable name="tablewidth" select="sum($cols/@w:w)"/>
    <xsl:element name="table">
      <xsl:attribute name="align" select="string('left')"/>
      <xsl:for-each select="$cols">
        <xsl:variable name="index" select="position()"/>
        <xsl:element name="col">
          <xsl:attribute name="id" select="concat('col',$index)"/>
          <xsl:attribute name="style" select="concat('width: ',@w:w div $tablewidth * 100,'%')"/>
        </xsl:element>
      </xsl:for-each>
      <xsl:variable name="thead" select="w:tr[w:trPr/w:tblHeader]"/>
      <xsl:if test="$thead">
        <xsl:element name="thead">
          <xsl:attribute name="valign" select="string('top')"/>
          <xsl:apply-templates select="$thead"/>
        </xsl:element>
      </xsl:if>
      <xsl:variable name="tbody" select="w:tr[not(w:trPr/w:tblHeader)]"/>
      <xsl:if test="$tbody">
        <xsl:element name="tbody">
          <xsl:attribute name="valign" select="string('top')"/>
          <xsl:apply-templates select="$tbody"/>
        </xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <xsl:template match="w:tr">
    <xsl:element name="tr">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="w:tc[boolean(.//w:vMerge and not(.//w:vMerge/@w:val))]">
    <!-- dit is een verticaal samengevoegde tabelcel -->
  </xsl:template>

  <xsl:template match="w:tc[parent::w:tr/w:trPr/w:tblHeader]">
    <xsl:element name="th">
      <xsl:attribute name="align">
        <xsl:call-template name="align"/>
      </xsl:attribute>
      <xsl:if test="w:tcPr/w:gridSpan/@w:val">
        <xsl:attribute name="colspan" select="w:tcPr/w:gridSpan/@w:val"/>
      </xsl:if>
      <xsl:variable name="rowspan" as="xs:integer">
        <xsl:call-template name="rowspan"/>
      </xsl:variable>
      <xsl:if test="$rowspan gt 1">
        <xsl:attribute name="rowspan" select="$rowspan"/>
      </xsl:if>
      <xsl:call-template name="group_adjacent">
        <xsl:with-param name="group" select="*"/>
      </xsl:call-template>
    </xsl:element>
  </xsl:template>

  <xsl:template match="w:tc">
    <xsl:element name="td">
      <xsl:attribute name="align">
        <xsl:call-template name="align"/>
      </xsl:attribute>
      <xsl:if test="w:tcPr/w:gridSpan/@w:val">
        <xsl:attribute name="colspan" select="w:tcPr/w:gridSpan/@w:val"/>
      </xsl:if>
      <xsl:variable name="rowspan" as="xs:integer">
        <xsl:call-template name="rowspan"/>
      </xsl:variable>
      <xsl:if test="$rowspan gt 1">
        <xsl:attribute name="rowspan" select="$rowspan"/>
      </xsl:if>
      <xsl:call-template name="group_adjacent">
        <xsl:with-param name="group" select="*"/>
      </xsl:call-template>
    </xsl:element>
  </xsl:template>

  <!-- routine om alignment te testen -->
  <xsl:template name="align">
    <xsl:variable name="align" select=".//w:jc[1]/@w:val"/>
    <xsl:choose>
      <xsl:when test="$align='left'">
        <xsl:value-of select="string('left')"/>
      </xsl:when>
      <xsl:when test="$align='right'">
        <xsl:value-of select="string('right')"/>
      </xsl:when>
      <xsl:when test="$align='center'">
        <xsl:value-of select="string('center')"/>
      </xsl:when>
      <xsl:when test="$align='both'">
        <!-- het zou justify moeten zijn, maar er wordt eigenlijk altijd left bedoeld -->
        <xsl:value-of select="string('left')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="string('left')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- bevat het aantal extra rijen van de verticaal samengevoegde tabelcel -->
  <xsl:template name="rowspan">
    <xsl:variable name="index" select="count(.|preceding-sibling::w:tc[not(w:tcPr/w:gridSpan)]) + sum(preceding-sibling::w:tc/w:tcPr/w:gridSpan/@w:val)"/>
    <xsl:variable name="check" select="parent::w:tr/following-sibling::w:tr/w:tc[count(.|preceding-sibling::w:tc[not(w:tcPr/w:gridSpan)]) + sum(preceding-sibling::w:tc/w:tcPr/w:gridSpan/@w:val)=$index]"/>
    <!-- check bevat de tabelcellen die van belang zijn -->
    <xsl:choose>
      <xsl:when test="$check">
        <xsl:for-each-group select="$check" group-adjacent="boolean(.//w:vMerge and not(.//w:vMerge/@w:val))">
          <xsl:if test="position()=1">
            <xsl:choose>
              <xsl:when test="current-group()[1][.//w:vMerge and not(.//w:vMerge/@w:val)]">
                <xsl:value-of select="count(current-group())+1"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="1"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </xsl:for-each-group>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- illustraties toevoegen -->

  <xsl:template match="w:drawing">
    <xsl:variable name="imageId" select=".//a:graphic//@r:embed"/>
    <xsl:choose>
      <xsl:when test="$imageId!=''">
        <xsl:variable name="imageName" select="document($relations,.)//*[@Id=$imageId]/@Target"/>
        <xsl:variable name="width">
          <xsl:variable name="sum" select="number((wp:anchor/wp:extent|wp:inline/a:graphic/a:graphicData/pic:pic/pic:spPr/a:xfrm/a:ext)[1]/@cx) div 635"/>
          <xsl:choose>
            <xsl:when test="$sum lt 75">
              <xsl:value-of select="$sum"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="100"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:element name="img">
          <xsl:attribute name="src" select="$imageName"/>
          <xsl:attribute name="alt" select="$imageName"/>
          <xsl:attribute name="style" select="concat('width: ',$width,'%')"/>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>