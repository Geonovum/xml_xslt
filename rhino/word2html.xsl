<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:my="http://www.eigen.nl" xmlns:wx="http://schemas.microsoft.com/office/word/2006/auxHint" xmlns:ve="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:asvg="http://schemas.microsoft.com/office/drawing/2016/SVG/main">
  <xsl:output method="xhtml" encoding="UTF-8" indent="no"/>

  <xsl:param name="temp.dir" select="fn:substring-before(fn:base-uri(),'unzip/word/document.xml')"/>

  <!-- domeinspecifieke instellingen -->
  <xsl:param name="nav_max_level" select="5"/>

  <!-- verkleiningsfactor van illustraties -->
  <xsl:param name="scale" select="0.75"/>

  <!-- scheidingsteken in paden -->
  <xsl:param name="delimiter" select="string('/')"/>

  <!-- verwijzingen naar gebruikte documenten -->
  <xsl:param name="config" select="fn:string-join(($temp.dir,'config.xml'),$delimiter)"/>
  <xsl:param name="comments" select="fn:string-join(($temp.dir,'unzip','word','comments.xml'),$delimiter)"/>
  <xsl:param name="endnotes" select="fn:string-join(($temp.dir,'unzip','word','endnotes.xml'),$delimiter)"/>
  <xsl:param name="footnotes" select="fn:string-join(($temp.dir,'unzip','word','footnotes.xml'),$delimiter)"/>
  <xsl:param name="numbering" select="fn:string-join(($temp.dir,'unzip','word','numbering.xml'),$delimiter)"/>
  <xsl:param name="relations" select="fn:string-join(($temp.dir,'unzip','word','_rels','document.xml.rels'),$delimiter)"/>
  <xsl:param name="settings" select="fn:string-join(($temp.dir,'unzip','word','settings.xml'),$delimiter)"/>
  <xsl:param name="styles" select="fn:string-join(($temp.dir,'unzip','word','styles.xml'),$delimiter)"/>
  <xsl:param name="props" select="fn:string-join(($temp.dir,'unzip','docProps','core.xml'),$delimiter)"/>

  <!-- options -->
  <xsl:param name="options" select="document('options.xml')/respec"/>

  <!-- respec -->
  <xsl:param name="respec">
    <xsl:copy-of select="document($config)/config/item[1]/node()"/>
  </xsl:param>

  <!-- workflow -->
  <xsl:param name="workflow">
    <xsl:copy-of select="document($config)/config/item[2]/node()"/>
  </xsl:param>

  <!-- title -->
  <xsl:param name="title">
    <xsl:value-of select="(document($settings,.)//w:docVar[@w:name='ID001']/@w:val,.//w:body/w:p[w:pPr(.)/w:name/@w:val='Title'][1],document($props,.)//dc:title)[1]"/>
  </xsl:param>

  <!-- langauge -->
  <xsl:param name="language" select="string('nl')"/>

  <!-- nummering koppenstructuur -->
  <xsl:param name="TOC_numbering">
    <xsl:for-each select="document($numbering)//w:abstractNum[w:name/@w:val='Koppenstructuur']/w:lvl">
      <xsl:element name="w:lvl">
        <xsl:attribute name="w:val" select="position()"/>
        <xsl:copy-of select="w:start|w:numFmt|w:lvlRestart|w:lvlText"/>
      </xsl:element>
    </xsl:for-each>
  </xsl:param>

  <!-- opmaakprofielen voor figuurbijschrift en tabeltitel -->
  <xsl:param name="figure_caption" select="('caption','Figuurbijschrift')"/>
  <xsl:param name="table_caption" select="('caption','Tabeltitel')"/>

  <!-- mappings -->

  <xsl:param name="numFmt_word" select="('bullet','decimal','lowerLetter','upperLetter','lowerRoman','upperRoman')"/>
  <xsl:param name="numFmt_html" select="('&#8226;','1','a','A','i','I')"/>

  <xsl:param name="list_word" select="('bullet','decimal','lowerLetter','upperLetter','lowerRoman','upperRoman')"/>
  <xsl:param name="list_html" select="('ul','ol','ol','ol','ol','ol')"/>

  <xsl:param name="border_word" select="('single','dashDotStroked','dashed','dashSmallGap','dotDash','dotDotDash','dotted','double','doubleWave','inset','nil','none','outset','thick','thickThinLargeGap','thickThinMediumGap','thickThinSmallGap','thinThickLargeGap','thinThickMediumGap','thinThickSmallGap','thinThickThinLargeGap','thinThickThinMediumGap','thinThickThinSmallGap','threeDEmboss','threeDEngrave','triple','wave')"/>
  <xsl:param name="border_html" select="('solid','dashed','dashed','dashed','dashed','dashed','dotted','double','double','inset','none','none','outset','solid','dashed','dashed','dashed','dashed','dashed','dashed','dashed','dashed','dashed','ridge','groove','double','solid')"/>

  <!-- maak de inhoudsopgave -->

  <xsl:param name="body">
    <!-- body bevat alles na de eerste heading 1 -->
    <xsl:for-each-group select="//w:body/node()" group-starting-with="(w:p[w:pPr(.)/w:name/@w:val='heading 1'])[1]">
      <xsl:choose>
        <xsl:when test="current-group()[1][w:pPr(.)/w:name/@w:val='heading 1']">
          <xsl:call-template name="body">
            <xsl:with-param name="group" select="current-group()"/>
            <xsl:with-param name="index" select="1"/>
            <xsl:with-param name="level" select="1"/>
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:param>

  <xsl:template name="body">
    <xsl:param name="group"/>
    <xsl:param name="index"/>
    <xsl:param name="level"/>
    <xsl:for-each-group select="$group" group-starting-with="w:p[w:pPr(.)/w:name/@w:val=(fn:format-number($index,'heading #'),fn:format-number($index,'Kop # bijlage'))]">
      <xsl:choose>
        <xsl:when test="$index gt 9">
          <xsl:element name="content">
            <xsl:copy-of select="current-group()"/>
          </xsl:element>
        </xsl:when>
        <xsl:when test="current-group()[1][w:pPr(.)/w:name/@w:val=fn:format-number($index,'heading #')]">
          <xsl:element name="section">
            <xsl:attribute name="id" select="current-group()[1]/@w14:paraId"/>
            <xsl:attribute name="level" select="$level"/>
            <xsl:attribute name="class" select="string('body')"/>
            <xsl:element name="properties">
              <xsl:copy-of select="current-group()[1]/preceding::w:sectPr[1]"/>
            </xsl:element>
            <xsl:element name="heading">
              <xsl:copy-of select="current-group()[1]"/>
            </xsl:element>
            <xsl:call-template name="body">
              <xsl:with-param name="group" select="subsequence(current-group(),2)"/>
              <xsl:with-param name="index" select="$index+1"/>
              <xsl:with-param name="level" select="$level+1"/>
            </xsl:call-template>
          </xsl:element>
        </xsl:when>
        <xsl:when test="current-group()[1][w:pPr(.)/w:name/@w:val=fn:format-number($index,'Kop # bijlage')]">
          <xsl:element name="section">
            <xsl:attribute name="id" select="current-group()[1]/@w14:paraId"/>
            <xsl:attribute name="level" select="$level"/>
            <xsl:attribute name="class" select="string('appendix')"/>
            <xsl:element name="heading">
              <xsl:copy-of select="current-group()[1]"/>
            </xsl:element>
            <xsl:call-template name="body">
              <xsl:with-param name="group" select="subsequence(current-group(),2)"/>
              <xsl:with-param name="index" select="$index+1"/>
              <xsl:with-param name="level" select="$level+1"/>
            </xsl:call-template>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="body">
            <xsl:with-param name="group" select="current-group()"/>
            <xsl:with-param name="index" select="$index+1"/>
            <xsl:with-param name="level" select="$level"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>

  <!-- Table Of Content -->
  <xsl:param name="TOC">
    <xsl:for-each select="$body//heading">
      <xsl:variable name="lvl" select="parent::section/@level"/>
      <xsl:variable name="class" select="parent::section/@class"/>
      <xsl:variable name="lvlText" select="$TOC_numbering/w:lvl[@w:val=$lvl]/w:lvlText/@w:val"/>
      <xsl:variable name="numFmt" select="$TOC_numbering/w:lvl[@w:val=$lvl]/w:numFmt/@w:val"/>
      <xsl:element name="heading">
        <xsl:attribute name="id" select="parent::section/@id"/>
        <xsl:attribute name="level" select="$lvl"/>
        <xsl:attribute name="class" select="$class"/>
        <xsl:element name="number">
          <xsl:for-each select="ancestor::section[heading]">
            <xsl:variable name="lvl" select="number(@level)"/>
            <xsl:variable name="count" select="if ($TOC_numbering/w:lvl[@w:val=$lvl]/w:lvlRestart/@w:val='0') then count(.|preceding::section[heading][@class=$class][@level=$lvl]) else count(.|preceding-sibling::section[heading][@class=$class][@level=$lvl])"/>
            <xsl:element name="item">
              <xsl:attribute name="count" select="$count"/>
              <xsl:if test="contains($lvlText,concat('%',$lvl))">
                <xsl:number value="$count" format="{$numFmt_html[fn:index-of($numFmt_word,$numFmt)]}"/>
              </xsl:if>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
        <xsl:element name="text">
          <xsl:copy-of select="w:p/node()"/>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
  </xsl:param>

  <!-- Table Of Figure -->
  <xsl:param name="TOF">
    <xsl:for-each select="$body//w:p/w:r/w:drawing">
      <xsl:element name="image">
        <xsl:attribute name="id" select="generate-id(.)"/>
        <xsl:attribute name="imageId" select="w:imageId(.)"/>
        <xsl:element name="number">
          <!-- we gaan ervan uit dat figuren in het hele document doortellen -->
          <xsl:element name="label">
            <xsl:value-of select="string('Figuur')"/>
          </xsl:element>
          <xsl:element name="item">
            <xsl:value-of select="position()"/>
          </xsl:element>
        </xsl:element>
        <xsl:element name="text">
          <xsl:for-each select="ancestor::w:p[1]/(.|following-sibling::element()[1][w:pPr(self::w:p)/w:name/@w:val=$figure_caption])//w:bookmarkStart">
            <xsl:copy-of select="."/>
          </xsl:for-each>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
  </xsl:param>

  <!-- Table Of Table -->
  <xsl:param name="TOT">
    <xsl:for-each select="$body//w:tbl">
      <xsl:element name="table">
        <xsl:attribute name="id" select="generate-id(.)"/>
        <xsl:element name="number">
          <!-- we gaan ervan uit dat tabellen in het hele document doortellen -->
          <xsl:element name="label">
            <xsl:value-of select="string('Tabel')"/>
          </xsl:element>
          <xsl:element name="item">
            <xsl:value-of select="position()"/>
          </xsl:element>
        </xsl:element>
        <xsl:element name="text">
          <xsl:for-each select="preceding-sibling::element()[1][w:pPr(self::w:p)/w:name/@w:val=$table_caption]//w:bookmarkStart">
            <xsl:copy-of select="."/>
          </xsl:for-each>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
  </xsl:param>

  <!-- linked data -->

  <xsl:param name="ld">
    <xsl:element name="keyword">
      <xsl:attribute name="name" select="string('@context')"/>
      <xsl:element name="item">
        <xsl:attribute name="noname" select="string('http://schema.org')"/>
        <xsl:element name="keyword">
          <xsl:attribute name="name" select="string('@vocab')"/>
          <xsl:value-of select="string('http://schema.org')"/>
        </xsl:element>
        <xsl:element name="keyword">
          <xsl:attribute name="name" select="string('@language')"/>
          <xsl:value-of select="$language"/>
        </xsl:element>
        <xsl:element name="foaf">
          <xsl:value-of select="string('http://xmlns.com/foaf/0.1')"/>
        </xsl:element>
        <xsl:element name="datePublished">
          <xsl:element name="keyword">
            <xsl:attribute name="name" select="string('@type')"/>
            <xsl:value-of select="string('http://www.w3.org/2001/XMLSchema#date')"/>
          </xsl:element>
        </xsl:element>
        <xsl:element name="inLanguage">
          <xsl:element name="keyword">
            <xsl:attribute name="name" select="string('@language')"/>
            <xsl:element name="null">
              <!-- reset de waarde -->
            </xsl:element>
          </xsl:element>
        </xsl:element>
        <xsl:element name="isBasedOn">
          <xsl:element name="keyword">
            <xsl:attribute name="name" select="string('@type')"/>
            <xsl:value-of select="string('@id')"/>
          </xsl:element>
        </xsl:element>
        <xsl:element name="license">
          <xsl:element name="keyword">
            <xsl:attribute name="name" select="string('@type')"/>
            <xsl:value-of select="string('@id')"/>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </xsl:element>
    <xsl:element name="id">
    </xsl:element>
    <xsl:element name="type">
      <xsl:element name="item">
        <xsl:value-of select="string('TechArticle')"/>
      </xsl:element>
    </xsl:element>
    <xsl:element name="name">
      <xsl:value-of select="$title"/>
    </xsl:element>
    <xsl:element name="inLanguage">
      <xsl:value-of select="$language"/>
    </xsl:element>
    <xsl:element name="license">
      <xsl:value-of select="$options/list[@id='license']/item[@id=$respec/license]"/>
    </xsl:element>
    <xsl:element name="datePublished">
      <xsl:value-of select="$respec/publishDate"/>
    </xsl:element>
    <xsl:element name="copyrightHolder">
      <xsl:element name="name">
        <xsl:value-of select="$workflow/company/name"/>
      </xsl:element>
      <xsl:element name="url">
        <xsl:value-of select="my:url($workflow/company/url)"/>
      </xsl:element>
    </xsl:element>
    <xsl:element name="discussionUrl">
      <xsl:value-of select="my:url($respec/issueBase)"/>
    </xsl:element>
    <xsl:element name="alternativeHeadline">
      <xsl:value-of select="$respec/subtitle"/>
    </xsl:element>
    <xsl:element name="isBasedOn">
      <xsl:value-of select="my:url(($workflow/company/docs,$respec/pubDomain,fn:string-join((lower-case(fn:substring-after($respec/previousMaturity,'GN-')),$respec/shortName,fn:format-date($respec/previousPublishDate,'[Y0001][M01][D01]','nl','AD','nl')),'-')))"/>
    </xsl:element>
    <xsl:element name="editor">
      <xsl:for-each select="$respec/editors/item">
        <xsl:element name="item">
          <xsl:element name="type">
            <xsl:value-of select="string('Person')"/>
          </xsl:element>
          <xsl:element name="name">
            <xsl:value-of select="./name"/>
          </xsl:element>
          <xsl:element name="worksFor">
            <xsl:element name="name">
              <xsl:value-of select="./company"/>
            </xsl:element>
            <xsl:element name="url">
              <xsl:value-of select="my:url(./companyURL)"/>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
    <xsl:element name="contributor">
      <xsl:for-each select="$respec/authors/item">
        <xsl:element name="item">
          <xsl:element name="type">
            <xsl:value-of select="string('Person')"/>
          </xsl:element>
          <xsl:element name="name">
            <xsl:value-of select="./name"/>
          </xsl:element>
          <xsl:element name="worksFor">
            <xsl:element name="name">
              <xsl:value-of select="./company"/>
            </xsl:element>
            <xsl:element name="url">
              <xsl:value-of select="my:url(./companyURL)"/>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
    <xsl:element name="citation">
      <xsl:element name="item"/>
    </xsl:element>
  </xsl:param>

  <!-- document -->

  <xsl:template match="w:document">
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
    <xsl:element name="html">
      <xsl:attribute name="lang" select="string('nl')"/>
      <xsl:element name="head">
        <xsl:element name="meta">
          <xsl:attribute name="content" select="string('text/html; charset=UTF-8')"/>
          <xsl:attribute name="http-equiv" select="string('content-type')"/>
        </xsl:element>
        <xsl:element name="meta">
          <xsl:attribute name="name" select="string('viewport')"/>
          <xsl:attribute name="content" select="string('width=device-width, initial-scale=1, shrink-to-fit=no')"/>
        </xsl:element>
        <xsl:element name="title">
          <xsl:apply-templates select="$title"/>
        </xsl:element>
        <xsl:element name="link">
          <xsl:attribute name="rel" select="string('stylesheet')"/>
          <xsl:attribute name="type" select="string('text/css')"/>
          <xsl:attribute name="href" select="my:url(($workflow/company/tools,'respec/style',concat($respec/specStatus,'.css')))"/>
        </xsl:element>
        <xsl:element name="link">
          <xsl:attribute name="rel" select="string('stylesheet')"/>
          <xsl:attribute name="type" select="string('text/css')"/>
          <xsl:attribute name="href" select="string('css/style.css')"/>
        </xsl:element>
        <xsl:element name="link">
          <xsl:attribute name="rel" select="string('shortcut icon')"/>
          <xsl:attribute name="type" select="string('image/x-icon')"/>
          <xsl:attribute name="href" select="my:url(($workflow/company/tools,'respec/style/logos',concat($workflow/company/name,'.svg')))"/>
        </xsl:element>
        <xsl:element name="script">
          <xsl:attribute name="id" select="string('initialUserConfig')"/>
          <xsl:attribute name="type" select="string('application/json')"/>
          <xsl:apply-templates select="$respec" mode="json-ld">
            <xsl:with-param name="level" select="0"/>
          </xsl:apply-templates>
        </xsl:element>
        <xsl:element name="script">
          <xsl:attribute name="type" select="string('application/ld+json')"/>
          <xsl:apply-templates select="$ld" mode="json-ld">
            <xsl:with-param name="level" select="0"/>
          </xsl:apply-templates>
        </xsl:element>
      </xsl:element>
      <xsl:apply-templates select="w:body"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="w:body">
    <xsl:element name="body">
      <!-- plaats div head -->
      <xsl:call-template name="head"/>
      <!-- plaats nav -->
      <xsl:call-template name="nav"/>
      <!-- plaats inhoud -->
      <xsl:apply-templates select="$body/section"/>
    </xsl:element>
  </xsl:template>

  <!-- json-ld -->

  <!-- parameter tab bepaalt de inspringing in json, parameter level bepaalt de diepte -->
  <xsl:param name="tab"><xsl:text>  </xsl:text></xsl:param>

  <xsl:template match="root()" mode="json-ld">
    <xsl:param name="level" as="xs:integer"/>
    <xsl:variable name="indent" select="for $index in 1 to $level return $tab"/>
    <xsl:value-of select="fn:string-join(($indent,'{&#10;'),'')"/>
    <xsl:apply-templates mode="json-ld">
      <xsl:with-param name="level" select="$level+1"/>
    </xsl:apply-templates>
    <xsl:value-of select="fn:string-join(($indent,'}','&#10;'),'')"/>
  </xsl:template>

  <xsl:template match="element()" mode="json-ld">
    <xsl:param name="level" as="xs:integer"/>
    <xsl:variable name="indent" select="for $index in 1 to $level return $tab"/>
    <xsl:variable name="name" select="if (name()='keyword') then @name else name()"/>
    <xsl:choose>
      <xsl:when test="item">
        <!-- item bevat een array -->
        <xsl:value-of select="fn:string-join(($indent,if (self::item) then '' else concat('&quot;',$name,'&quot;: '),'[&#10;'),'')"/>
        <xsl:apply-templates mode="json-ld">
          <xsl:with-param name="level" select="$level+1"/>
        </xsl:apply-templates>
        <xsl:value-of select="fn:string-join(($indent,']',if (following-sibling::element()) then ',' else '','&#10;'),'')"/>
      </xsl:when>
      <xsl:when test="null">
        <xsl:value-of select="fn:string-join(($indent,if (self::item) then '' else concat('&quot;',$name,'&quot;: ')),'')"/>
        <xsl:value-of select="string('null')"/>
        <xsl:value-of select="fn:string-join((if (following-sibling::element()) then ',' else '','&#10;'),'')"/>
      </xsl:when>
      <xsl:when test="element()">
        <xsl:apply-templates select="@noname" mode="json-ld">
          <xsl:with-param name="level" select="$level"/>
        </xsl:apply-templates>
        <xsl:value-of select="fn:string-join(($indent,if (self::item) then '' else concat('&quot;',$name,'&quot;: '),'{&#10;'),'')"/>
        <xsl:apply-templates select="node()" mode="json-ld">
          <xsl:with-param name="level" select="$level+1"/>
        </xsl:apply-templates>
        <xsl:value-of select="fn:string-join(($indent,'}',if (following-sibling::element()) then ',' else '','&#10;'),'')"/>
      </xsl:when>
      <xsl:when test="text()">
        <xsl:value-of select="fn:string-join(($indent,if (self::item) then '' else concat('&quot;',$name,'&quot;: '),'&quot;'),'')"/>
        <xsl:apply-templates select="text()" mode="json-ld"/>
        <xsl:value-of select="fn:string-join(('&quot;',if (following-sibling::element()) then ',' else '','&#10;'),'')"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="attribute()" mode="json-ld">
    <xsl:param name="level" as="xs:integer"/>
    <xsl:variable name="indent" select="for $index in 1 to $level return $tab"/>
    <xsl:value-of select="fn:string-join(($indent,'&quot;'),'')"/>
    <xsl:value-of select="."/>
    <xsl:value-of select="fn:string-join(('&quot;:&#10;'),'')"/>
  </xsl:template>

  <xsl:template match="text()" mode="json-ld">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>

  <!-- head -->

  <xsl:template name="head">
    <xsl:element name="div">
      <xsl:attribute name="class" select="string('head')"/>
      <xsl:element name="a">
        <!--xsl:attribute name="href" select="my:url($workflow/company/url)"/-->
        <xsl:element name="img">
          <xsl:attribute name="id" select="$workflow/company/name"/>
          <xsl:attribute name="alt" select="$workflow/company/name"/>
          <xsl:attribute name="width" select="string('240')"/>
          <xsl:attribute name="height" select="string('44')"/>
          <xsl:attribute name="src" select="my:url(($workflow/company/tools,'respec/style/logos',concat($workflow/domain/name,'.svg')))"/>
        </xsl:element>
      </xsl:element>
      <xsl:element name="h1">
        <xsl:attribute name="class" select="string('title p-name')"/>
        <xsl:attribute name="id" select="string('title')"/>
        <xsl:value-of select="$title"/>
      </xsl:element>
      <xsl:element name="h2">
        <xsl:value-of select="$respec/generatedSubtitle"/>
      </xsl:element>
      <xsl:element name="dl">
        <xsl:element name="dt">
          <xsl:text>Versie:</xsl:text>
        </xsl:element>
        <xsl:element name="dd">
          <xsl:value-of select="$workflow/document/version"/>
        </xsl:element>
        <xsl:element name="dt">
          <xsl:text>Datum:</xsl:text>
        </xsl:element>
        <xsl:element name="dd">
          <xsl:value-of select="fn:format-date($respec/publishDate,'[D1] [Mn] [Y1]','nl','AD','nl')"/>
        </xsl:element>
        <xsl:element name="dt">
          <xsl:value-of select="if (count($respec/authors/item) eq 1) then 'Auteur:' else 'Auteurs:'"/>
        </xsl:element>
        <xsl:for-each select="$respec/authors/item">
          <xsl:variable name="item" select="."/>
          <xsl:element name="dd">
            <xsl:attribute name="class" select="string('p-author h-card vcard')"/>
            <xsl:element name="span">
              <xsl:attribute name="class" select="string('p-name fn')"/>
              <xsl:value-of select="$item/name"/>
              <xsl:text>, </xsl:text>
              <xsl:element name="a">
                <xsl:attribute name="class" select="string('p-org org h-org h-card')"/>
                <xsl:attribute name="href" select="my:url($item/companyURL)"/>
                <xsl:value-of select="$item/company"/>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
        <xsl:element name="dt">
          <xsl:value-of select="if (count($respec/editors/item) eq 1) then 'Redacteur:' else 'Redacteurs:'"/>
        </xsl:element>
        <xsl:for-each select="$respec/editors/item">
          <xsl:variable name="item" select="."/>
          <xsl:element name="dd">
            <xsl:attribute name="class" select="string('p-editor h-card vcard')"/>
            <xsl:element name="span">
              <xsl:attribute name="class" select="string('p-name fn')"/>
              <xsl:value-of select="$item/name"/>
              <xsl:text>, </xsl:text>
              <xsl:element name="a">
                <xsl:attribute name="class" select="string('p-org org h-org h-card')"/>
                <xsl:attribute name="href" select="my:url($item/companyURL)"/>
                <xsl:value-of select="$item/company"/>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:for-each>
        <xsl:element name="dt">
          <xsl:text>Geldende versie:</xsl:text>
        </xsl:element>
        <xsl:element name="dd">
          <xsl:element name="a">
            <xsl:attribute name="class" select="string('u-url')"/>
            <xsl:attribute name="href" select="my:url($workflow/document/currentVersion)"/>
            <xsl:value-of select="my:url($workflow/document/currentVersion)"/>
          </xsl:element>
        </xsl:element>
        <!-- laatst gepubliceerde versie is niet zichtbaar -->
        <!--xsl:element name="dt">
          <xsl:text>Laatst gepubliceerde versie:</xsl:text>
        </xsl:element>
        <xsl:element name="dd">
          <xsl:element name="a">
            <xsl:attribute name="href" select="my:url($workflow/document/lastPublishedVersion)"/>
            <xsl:value-of select="my:url($workflow/document/lastPublishedVersion)"/>
          </xsl:element>
        </xsl:element-->
        <xsl:if test="$workflow/document/lastVersion">
          <xsl:element name="dt">
            <xsl:text>Vorige versie:</xsl:text>
          </xsl:element>
          <xsl:element name="dd">
            <xsl:element name="a">
              <xsl:attribute name="href" select="my:url($workflow/document/lastVersion)"/>
              <xsl:value-of select="my:url($workflow/document/lastVersion)"/>
            </xsl:element>
          </xsl:element>
        </xsl:if>
        <!-- laatste werkversie is niet zichtbaar -->
        <!--xsl:element name="dt">
          <xsl:text>Laatste werkversie:</xsl:text>
        </xsl:element>
        <xsl:element name="dd">
          <xsl:element name="a">
            <xsl:attribute name="href" select="my:url($respec/edDraftURI)"/>
            <xsl:value-of select="my:url($respec/edDraftURI)"/>
          </xsl:element>
        </xsl:element-->
        <xsl:element name="dt">
          <xsl:text>Contact:</xsl:text>
        </xsl:element>
        <xsl:element name="dd">
          <xsl:element name="a">
            <xsl:attribute name="href" select="concat('mailto:',$workflow/domain/contact)"/>
            <xsl:value-of select="$workflow/domain/contact"/>
          </xsl:element>
        </xsl:element>
        <xsl:element name="dt">
          <xsl:text>Rechtenbeleid:</xsl:text>
        </xsl:element>
        <xsl:element name="dd">
          <xsl:element name="div">
            <xsl:attribute name="class" select="string('copyright')"/>
            <xsl:element name="div">
              <xsl:element name="abbr">
                <xsl:attribute name="title" select="$options/list[@id='license']/item[@id=$respec/license]"/>
                <xsl:element name="a">
                  <xsl:attribute name="href" select="concat('https://creativecommons.org/licenses/',fn:substring-after($respec/license,'cc-'),'/4.0/legalcode.nl')"/>
                  <xsl:element name="img">
                    <xsl:attribute name="width" select="115"/>
                    <xsl:attribute name="height" select="40"/>
                    <xsl:attribute name="src" select="my:url(($workflow/company/tools,'respec/style/logos',concat($respec/license,'.svg')))"/>
                    <xsl:attribute name="alt" select="$options/list[@id='license']/item[@id=$respec/license]"/>
                  </xsl:element>
                </xsl:element>
              </xsl:element>
            </xsl:element>
            <xsl:element name="div">
              <xsl:element name="p">
                <xsl:value-of select="$options/list[@id='license']/item[@id=$respec/license]"/>
                <xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
                <xsl:value-of select="concat('(',upper-case($respec/license),')')"/>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:element>
      <xsl:element name="hr">
        <xsl:attribute name="title" select="string('Separator for header')"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- nav -->

  <xsl:template name="nav">
    <xsl:element name="nav">
      <xsl:attribute name="id" select="string('toc')"/>
      <xsl:element name="h2">
        <xsl:attribute name="class" select="string('introductory')"/>
        <xsl:attribute name="id" select="string('inhoudsopgave')"/>
        <xsl:text>Inhoudsopgave</xsl:text>
      </xsl:element>
      <xsl:element name="ol">
        <xsl:attribute name="class" select="string('toc')"/>
        <xsl:apply-templates select="$body/section" mode="nav"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="section" mode="nav">
    <xsl:element name="li">
      <xsl:attribute name="class" select="string('tocline')"/>
      <xsl:apply-templates select="heading" mode="nav"/>
      <xsl:choose>
        <xsl:when test="number(@level) lt $nav_max_level">
          <xsl:element name="ol">
            <xsl:attribute name="class" select="string('toc')"/>
            <xsl:apply-templates select="section" mode="nav"/>
          </xsl:element>
        </xsl:when>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template match="heading" mode="nav">
    <xsl:variable name="id" select="parent::section/@id"/>
    <xsl:variable name="heading" select="$TOC/heading[@id=$id]"/>
    <xsl:element name="a">
      <xsl:attribute name="class" select="string('tocxref')"/>
      <xsl:attribute name="href" select="concat('#',$id)"/>
      <xsl:element name="span">
        <xsl:attribute name="class" select="string('secno')"/>
        <xsl:value-of select="concat(fn:string-join($heading/number/item[. ne ''],'.'),' ')"/>
      </xsl:element>
      <xsl:apply-templates select="$heading/text" mode="nav"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="text" mode="nav">
    <xsl:apply-templates select="w:r"/>
  </xsl:template>

  <!-- plaats elementen hiërarchisch -->

  <xsl:template match="section">
    <xsl:choose>
      <xsl:when test="number(@level) lt 6">
        <xsl:element name="section">
          <xsl:attribute name="id" select="@id"/>
          <xsl:attribute name="class" select="@class"/>
          <xsl:apply-templates select="node()"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="div">
          <xsl:attribute name="id" select="@id"/>
          <xsl:attribute name="class" select="@class"/>
          <xsl:apply-templates select="node()"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="content">
    <xsl:call-template name="group_adjacent">
      <xsl:with-param name="group" select="node()"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="heading">
    <!-- alle koppen gaan één niveau omlaag -->
    <xsl:variable name="id" select="parent::section/@id"/>
    <xsl:variable name="heading" select="$TOC/heading[@id eq $id]"/>
    <xsl:choose>
      <xsl:when test="number($heading/@level) lt 6">
        <xsl:element name="{concat('h',$heading/@level+1)}">
          <xsl:attribute name="id" select="concat('x',fn:string-join(($heading/number/item[. ne ''],$id),'-'))"/>
          <xsl:element name="span">
            <xsl:attribute name="class" select="string('secno')"/>
            <xsl:value-of select="concat(fn:string-join($heading/number/item[. ne ''],'.'),'&#8194;')"/>
          </xsl:element>
          <xsl:apply-templates select="$heading/text"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="p">
          <xsl:attribute name="class" select="concat('heading',$heading/@level+1)"/>
          <xsl:element name="span">
            <xsl:attribute name="class" select="string('secno')"/>
            <xsl:value-of select="concat(fn:string-join($heading/number/item[. ne ''],'.'),'&#8194;')"/>
          </xsl:element>
          <xsl:apply-templates select="$heading/text"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- groepeer elementen niet-hiërarchisch -->

  <xsl:template name="group_adjacent">
    <xsl:param name="group"/>
    <xsl:for-each-group select="$group" group-adjacent="if (self::w:p[w:r/w:drawing]|self::w:p[w:pPr(.)/w:name/@w:val=$figure_caption][preceding-sibling::w:p[1][w:r/w:drawing]]) then 'figuur' else if (self::w:tbl|self::w:p[w:pPr(.)/w:name/@w:val=$table_caption][following-sibling::element()[1][self::w:tbl]]) then 'tabel' else if (w:lvl(w:pPr(self::w:p[descendant::w:t])/w:numPr)[w:numFmt/@w:val=$list_word]) then 'lijst' else if (self::w:p[w:r/w:rPr/w:highlight/@w:val]) then fn:distinct-values(self::w:p/w:r/w:rPr/w:highlight/@w:val) else if (self::w:p[w:sdt/w:sdtPr/w14:checkbox]) then 'check' else 'standaard'">
      <xsl:choose>
        <xsl:when test="current-grouping-key()='figuur'">
          <xsl:for-each-group select="current-group()" group-starting-with="self::w:p[w:r/w:drawing]">
            <xsl:variable name="id" select="current-group()/self::w:p/w:r/w:drawing/generate-id(.)"/>
            <xsl:variable name="image" select="$TOF/image[@id=$id]"/>
            <xsl:element name="figure">
              <!-- plaats de bookmarks voor img, niet voor figcaption -->
              <xsl:apply-templates select="$image/text/w:bookmarkStart"/>
              <xsl:apply-templates select="current-group()/self::w:p/w:r/w:drawing"/>
              <xsl:element name="figcaption">
                <xsl:attribute name="id" select="$image/@id"/>
                <xsl:value-of select="concat($image/number/label,' ')"/>
                <xsl:element name="span">
                  <xsl:attribute name="class" select="string('figno')"/>
                  <xsl:value-of select="fn:string-join($image/number/item[. ne ''],'.')"/>
                </xsl:element>
                <xsl:value-of select="string('&#8194;')"/>
                <xsl:element name="span">
                  <xsl:attribute name="class" select="string('fig-title')"/>
                  <xsl:apply-templates select="current-group()/self::w:p[w:pPr(.)/w:name/@w:val=$figure_caption]/node() except w:bookmarkStart"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:for-each-group>
        </xsl:when>
        <xsl:when test="current-grouping-key()='tabel'">
          <xsl:for-each-group select="current-group()" group-ending-with="self::w:tbl">
            <xsl:apply-templates select="current-group()/self::w:tbl">
              <xsl:with-param name="caption" select="current-group()/self::w:p[w:pPr(.)/w:name/@w:val=$table_caption]/node()"/>
            </xsl:apply-templates>
          </xsl:for-each-group>
        </xsl:when>
        <xsl:when test="current-grouping-key()='lijst'">
          <xsl:call-template name="lijst">
            <xsl:with-param name="group" select="current-group()"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="current-grouping-key()='cyan'">
          <!-- highlight cyan wordt gebruikt om een code-blok aan te geven -->
          <xsl:element name="pre">
            <xsl:attribute name="class" select="string('example')"/>
            <xsl:element name="code">
              <xsl:for-each select="current-group()/self::w:p">
                <xsl:apply-templates select="node()"/>
                <xsl:text>&#10;</xsl:text>
              </xsl:for-each>
            </xsl:element>
          </xsl:element>
        </xsl:when>
        <xsl:when test="current-grouping-key()='green'">
          <!-- highlight green wordt gebruikt om een noot aan te geven -->
          <xsl:element name="aside">
            <xsl:attribute name="class" select="string('note')"/>
            <xsl:apply-templates select="current-group()"/>
          </xsl:element>
        </xsl:when>
        <xsl:when test="current-grouping-key()='magenta'">
          <!-- highlight yellow wordt gebruikt om een redactionele noot aan te geven -->
          <xsl:element name="aside">
            <xsl:attribute name="class" select="string('ednote')"/>
            <xsl:apply-templates select="current-group()"/>
          </xsl:element>
        </xsl:when>
        <xsl:when test="current-grouping-key()='yellow'">
          <!-- highlight yellow wordt gebruikt om een voorbeeld aan te geven -->
          <xsl:element name="aside">
            <xsl:attribute name="class" select="string('example')"/>
            <xsl:apply-templates select="current-group()"/>
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
        <xsl:otherwise>
          <xsl:comment><xsl:value-of select="concat('[GW: ',current-grouping-key(),']')"/></xsl:comment>
          <xsl:apply-templates select="current-group()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>

  <!-- groepeer element lijst -->

  <xsl:template name="lijst">
    <xsl:param name="group"/>
    <!-- id is een combinatie van w:numId en w:ilvl -->
    <xsl:variable name="id" select="fn:string-join(w:lvl(w:pPr($group[1])/w:numPr)/element()/@w:val)"/>
    <xsl:variable name="type" select="($list_html[fn:index-of($list_word,w:lvl(w:pPr($group[1])/w:numPr)/w:numFmt/@w:val)],'ul')[1]"/>
    <xsl:element name="{$type}">
      <xsl:for-each-group select="$group" group-starting-with="self::w:p[(fn:string-join(w:lvl(w:pPr(.)/w:numPr)/element()/@w:val)=$id) and not(w:pPr(.)/w:numPr/w:numId/@w:val=0)]">
        <xsl:element name="li">
          <!-- verwerk geneste opsommingen -->
          <xsl:for-each-group select="current-group()" group-adjacent="if (fn:string-join(w:lvl(w:pPr(self::w:p)/w:numPr)/element()/@w:val)=$id) then 'item' else 'lijst'">
            <xsl:choose>
              <xsl:when test="current-grouping-key() eq 'item'">
                <xsl:apply-templates select="current-group()/self::w:p"/>
              </xsl:when>
              <xsl:when test="current-grouping-key() eq 'lijst'">
                <xsl:call-template name="lijst">
                  <xsl:with-param name="group" select="current-group()"/>
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
    <xsl:variable name="id" select="@w14:paraId"/>
    <xsl:variable name="style" select="(w:pPr(.)/w:name/@w:val,'Normal')[1]"/>
    <xsl:choose>
      <xsl:when test="not(descendant::w:t|descendant::w:drawing)">
        <!-- lege alinea -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="p">
          <!-- controleer op witruimte -->
          <xsl:choose>
            <xsl:when test="following-sibling::element()[1][not(descendant::w:t|descendant::w:drawing)]">
              <xsl:attribute name="class" select="string('space-after')"/>
            </xsl:when>
            <xsl:when test="w:pPr(self::w:p)/w:spacing[1]/@w:lineRule">
              <xsl:choose>
                <xsl:when test="not(following-sibling::element()[1])">
                  <!-- geen witregel -->
                </xsl:when>
                <xsl:when test="w:pPr(following-sibling::element()[1])/w:spacing[1]/@w:lineRule">
                  <!-- geen witregel -->
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class" select="string('space-after')"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="number(w:pPr(self::w:p)/w:spacing[1]/@w:after) gt 0">
              <xsl:attribute name="class" select="string('space-after')"/>
            </xsl:when>
            <xsl:otherwise>
              <!-- geen witregel -->
            </xsl:otherwise>
          </xsl:choose>
          <!-- plaats indentation, alleen van w:p zonder nummering -->
          <xsl:if test="self::w:p/w:pPr[not(w:numPr)]/w:ind/@w:left">
            <xsl:attribute name="style" select="concat('margin-left: ',fn:format-number(number(self::w:p/w:pPr/w:ind/@w:left) * 0.0176388889,'#.#'),'mm;')"/>
          </xsl:if>
          <xsl:apply-templates select="node()"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- hyperlink -->

  <xsl:template match="w:hyperlink[@r:id]">
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

  <xsl:template match="w:hyperlink[@w:anchor]">
    <xsl:variable name="id" select="@w:anchor"/>
    <xsl:variable name="heading" select="$TOC/heading[text/w:bookmarkStart/@w:name=$id]"/>
    <xsl:choose>
      <xsl:when test="$heading">
        <xsl:element name="a">
          <xsl:attribute name="href" select="concat('#',$heading/@id)"/>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- bookmark -->

  <xsl:template match="w:bookmarkStart">
    <xsl:choose>
      <xsl:when test="fn:starts-with(./@w:name,'_Toc')">
        <!-- doe niets, alleen voor inhoudsopgave -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="a">
          <xsl:attribute name="name" select="@w:name"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- velden bewerken -->

  <xsl:template match="w:instrText">
    <!-- tekst niet plaatsen -->
  </xsl:template>

  <xsl:template match="w:t[preceding::w:fldChar[1]/@w:fldCharType='separate']">
    <xsl:variable name="instrText" select="preceding::w:fldChar[2][@w:fldCharType='begin']/following::w:instrText[1]/normalize-space(text())"/>
    <xsl:choose>
      <xsl:when test="fn:tokenize($instrText,'\s+')[1]='REF'">
        <xsl:variable name="ref" select="fn:tokenize($instrText,'\s+')[2]"/>
        <xsl:variable name="number" select="($TOC/heading[text/w:bookmarkStart/@w:name=$ref]/number,$TOF/image[text/w:bookmarkStart/@w:name=$ref]/number,$TOT/table[text/w:bookmarkStart/@w:name=$ref]/number)[1]"/>
        <xsl:element name="a">
          <xsl:attribute name="href" select="concat('#',$ref)"/>
          <xsl:choose>
            <xsl:when test="$number">
              <xsl:value-of select="fn:string-join(($number/label,fn:string-join($number/item[. ne ''],'.')),' ')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="w:t">
    <!-- w:r handelt begin- en eindspaties af -->
    <xsl:apply-templates select="normalize-space(.)"/>
  </xsl:template>

  <!-- range bewerken -->

  <xsl:template match="w:r">
    <!-- als onderliggende w:t begin- en eindspaties bevatten, moeten die buiten w:r geplaatst worden -->
    <xsl:variable name="check" select="fn:tokenize(w:t,'\s+')"/>
    <xsl:choose>
      <xsl:when test="($check[1] eq '') and ($check[2] eq '')">
        <!-- alleen een spatie -->
        <xsl:text> </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <!-- w:t bevat normalize-space -->
        <xsl:if test="$check[1] eq ''">
          <xsl:text> </xsl:text>
        </xsl:if>
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
        <xsl:if test="$check[last()] eq ''">
          <xsl:text> </xsl:text>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--routine om elementen in w:rPr af te splitsen-->
  <xsl:template name="range">
    <xsl:param name="node"/>
    <xsl:param name="index"/>
    <xsl:choose>
      <xsl:when test="w:rPr/element()[$index]">
        <xsl:choose>
          <xsl:when test="name($node/w:rPr/element()[$index])='w:rStyle'">
            <xsl:variable name="styleId" select="$node/w:rPr/w:rStyle/@w:val"/>
            <xsl:variable name="styleName" select="document($styles,.)/w:styles/w:style[@w:styleId=$styleId]/w:name/@w:val"/>
            <!-- hier kan een choose op basis van styleName -->
            <xsl:call-template name="range">
              <xsl:with-param name="node" select="$node"/>
              <xsl:with-param name="index" select="$index+1"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="name($node/w:rPr/element()[$index])='w:highlight'">
            <!-- geldt alleen binnen alinea -->
            <xsl:choose>
              <xsl:when test="$node/ancestor::w:p/w:r[not(w:rPr/w:highlight)]">
                <xsl:element name="span">
                  <xsl:attribute name="style" select="concat('background-color: ',$node/w:rPr/w:highlight/@w:val,';')"/>
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
          </xsl:when>
          <xsl:when test="name($node/w:rPr/element()[$index])='w:color'">
            <xsl:element name="span">
              <xsl:attribute name="style" select="concat('color: #',$node/w:rPr/w:color/@w:val,';')"/>
              <xsl:call-template name="range">
                <xsl:with-param name="node" select="$node"/>
                <xsl:with-param name="index" select="$index+1"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:when>
          <!--xsl:when test="name(w:rPr/element()[$index]) = 'w:rFonts'">
            <xsl:call-template name="range">
              <xsl:with-param name="node" select="$node"/>
              <xsl:with-param name="index" select="$index+1"/>
            </xsl:call-template>
          </xsl:when-->
          <xsl:when test="name($node/w:rPr/element()[$index])='w:b'">
            <xsl:element name="b">
              <xsl:call-template name="range">
                <xsl:with-param name="node" select="$node"/>
                <xsl:with-param name="index" select="$index+1"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:when>
          <xsl:when test="name($node/w:rPr/element()[$index])='w:i'">
            <xsl:element name="i">
              <xsl:call-template name="range">
                <xsl:with-param name="node" select="$node"/>
                <xsl:with-param name="index" select="$index+1"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:when>
          <xsl:when test="name($node/w:rPr/element()[$index])='w:u'">
            <xsl:element name="u">
              <xsl:call-template name="range">
                <xsl:with-param name="node" select="$node"/>
                <xsl:with-param name="index" select="$index+1"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:when>
          <xsl:when test="name($node/w:rPr/element()[$index])='w:vertAlign'">
            <xsl:element name="{fn:substring($node/w:rPr/w:vertAlign/@w:val,1,3)}">
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
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="$node/node()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- nootverwijzingen toevoegen -->

  <xsl:template match="w:footnoteReference">
    <xsl:variable name="footnoteId" select="@w:id"/>
    <xsl:variable name="footnote" select="document($footnotes,.)//w:footnote[@w:id=$footnoteId]"/>
    <xsl:variable name="index" select="count(.|preceding::w:footnoteReference)"/>
    <xsl:element name="span">
      <xsl:attribute name="class" select="string('noot')"/>
      <xsl:number value="$index" format="[1]"/>
      <xsl:element name="span">
        <xsl:attribute name="class" select="string('noottekst')"/>
        <xsl:for-each select="$footnote/w:p">
          <xsl:apply-templates select="./node()"/>
          <xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
        </xsl:for-each>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- eindnootverwijzingen toevoegen -->

  <xsl:template match="w:endnoteReference">
    <xsl:variable name="endnoteId" select="@w:id"/>
    <xsl:variable name="endnote" select="document($endnotes,.)//w:endnote[@w:id=$endnoteId]"/>
    <xsl:variable name="index" select="count(.|preceding::w:endnoteReference)"/>
    <xsl:element name="span">
      <xsl:attribute name="class" select="string('noot')"/>
      <xsl:number value="$index" format="[i]"/>
      <xsl:element name="span">
        <xsl:attribute name="class" select="string('noottekst')"/>
        <xsl:for-each select="$endnote/w:p">
          <xsl:apply-templates select="./node()"/>
          <xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
        </xsl:for-each>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- tekens -->

  <xsl:template match="w:br">
    <xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
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
    <xsl:param name="caption"/>
    <xsl:variable name="id" select="generate-id(.)"/>
    <xsl:variable name="cols" select="w:tblGrid/w:gridCol"/>
    <xsl:variable name="tablewidth" select="sum($cols/@w:w)"/>
    <xsl:element name="table">
      <xsl:attribute name="style" select="if ($tablewidth gt 6500) then string('width: 100%;') else concat('width: ',string($tablewidth div 20),'pt;')"/>
      <xsl:element name="caption">
        <xsl:attribute name="id" select="$id"/>
        <xsl:value-of select="concat($TOT/table[@id=$id]/number/label,' ')"/>
        <xsl:element name="span">
          <xsl:attribute name="class" select="string('tblno')"/>
          <xsl:value-of select="fn:string-join($TOT/table[@id=$id]/number/item[. ne ''],'.')"/>
        </xsl:element>
        <xsl:value-of select="string('&#8194;')"/>
        <xsl:element name="span">
          <xsl:attribute name="class" select="string('tbl-title')"/>
          <xsl:apply-templates select="$caption"/>
        </xsl:element>
      </xsl:element>
      <xsl:element name="colgroup">
        <xsl:for-each select="$cols">
          <xsl:variable name="index" select="position()"/>
          <xsl:element name="col">
            <xsl:attribute name="id" select="concat('col',$index)"/>
            <xsl:attribute name="style" select="concat('width: ',@w:w div $tablewidth * 100,'%;')"/>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
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
      <xsl:attribute name="style">
        <xsl:call-template name="props">
          <xsl:with-param name="outputstring" select="string('')"/>
          <xsl:with-param name="index" select="1"/>
        </xsl:call-template>
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
        <xsl:with-param name="group" select="node()"/>
      </xsl:call-template>
    </xsl:element>
  </xsl:template>

  <xsl:template match="w:tc">
    <xsl:element name="td">
      <xsl:attribute name="align">
        <xsl:call-template name="align"/>
      </xsl:attribute>
      <xsl:attribute name="style">
        <xsl:call-template name="props">
          <xsl:with-param name="outputstring" select="string('')"/>
          <xsl:with-param name="index" select="1"/>
        </xsl:call-template>
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
        <xsl:with-param name="group" select="node()"/>
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

  <!-- routine om margin te testen -->
  <xsl:template name="margin">
    <xsl:param name="check"/>
    <!-- controleer of w:tc een marge heeft -->
    <xsl:variable name="tcMar" select="w:tcPr/w:tcMar/element()[name()=concat('w:', $check)]/@w:w"/>
    <xsl:choose>
      <xsl:when test="$tcMar">
        <xsl:value-of select="concat(string(number($tcMar) div 20), 'pt')"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- controleer of w:tbl een marge heeft -->
        <xsl:variable name="tblCellMar" select="ancestor::w:tbl[1]/w:tblPr/w:tblCellMar/element()[name()=concat('w:', $check)]/@w:w"/>
        <xsl:choose>
          <xsl:when test="$tblCellMar">
            <xsl:value-of select="concat(string(number($tblCellMar) div 20), 'pt')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="string('0pt')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- routine om props te verzamelen -->
  <xsl:template name="props">
    <xsl:param name="outputstring"/>
    <xsl:param name="index"/>
    <!-- haal de stijl op -->
    <xsl:variable name="styleId" select="ancestor::w:tbl[1]/w:tblPr/w:tblStyle/@w:val"/>
    <xsl:variable name="style" select="document($styles,.)//w:style[@w:styleId=$styleId]"/>
    <!-- check bevat de gegevens die we willen controleren -->
    <xsl:variable name="check" select="('top','left','bottom','right','background')"/>
    <xsl:choose>
      <xsl:when test="$check[$index]='top' or $check[$index]='bottom'">
        <!-- controleer de marge -->
        <xsl:variable name="margin">
          <xsl:call-template name="margin">
            <xsl:with-param name="check" select="$check[$index]"/>
          </xsl:call-template>
        </xsl:variable>
        <!-- controleer of w:tc een rand heeft -->
        <xsl:variable name="tcBorder" select="w:tcPr/w:tcBorders/element()[local-name()=$check[$index]]"/>
        <xsl:choose>
          <xsl:when test="$tcBorder">
            <xsl:call-template name="props">
              <xsl:with-param name="outputstring" select="concat($outputstring,' border-',$check[$index],': ',string(number(($tcBorder/@w:sz,'0')[1]) div 8),'pt ',$border_html[fn:index-of($border_word,$tcBorder/@w:val)],' #',replace($tcBorder/@w:color,'auto','000000'),';')"/>
              <xsl:with-param name="index" select="$index+1"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <!-- controleer of w:tbl een rand heeft -->
            <xsl:variable name="tblBorder" select="($style,ancestor::w:tbl[1])[1]/w:tblPr/w:tblBorders/w:insideH"/>
            <xsl:choose>
              <xsl:when test="$tblBorder">
                <xsl:call-template name="props">
                  <xsl:with-param name="outputstring" select="concat($outputstring,' border-',$check[$index],': ',string(number(($tblBorder/@w:sz,'0')[1]) div 8),'pt ',$border_html[fn:index-of($border_word,$tblBorder/@w:val)],' #',replace($tblBorder/@w:color,'auto','000000'),';')"/>
                  <xsl:with-param name="index" select="$index+1"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="props">
                  <xsl:with-param name="outputstring" select="concat($outputstring,' border-',$check[$index],': 0pt none #000000;')"/>
                  <xsl:with-param name="index" select="$index+1"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$check[$index]='left' or $check[$index]='right'">
        <!-- controleer de marge -->
        <xsl:variable name="margin">
          <xsl:call-template name="margin">
            <xsl:with-param name="check" select="$check[$index]"/>
          </xsl:call-template>
        </xsl:variable>
        <!-- controleer of w:tc een rand heeft -->
        <xsl:variable name="tcBorder" select="w:tcPr/w:tcBorders/element()[name()=concat('w:',$check[$index])]"/>
        <xsl:choose>
          <xsl:when test="$tcBorder">
            <xsl:call-template name="props">
              <xsl:with-param name="outputstring" select="concat($outputstring,' border-',$check[$index],': ',string(number(($tcBorder/@w:sz,'0')[1]) div 8),'pt ',$border_html[fn:index-of($border_word,$tcBorder/@w:val)],' #',replace($tcBorder/@w:color,'auto','000000'),';')"/>
              <xsl:with-param name="index" select="$index+1"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <!-- controleer of w:tbl een rand heeft -->
            <xsl:variable name="tblBorder" select="($style,ancestor::w:tbl[1])[1]/w:tblPr/w:tblBorders/w:insideV"/>
            <xsl:choose>
              <xsl:when test="$tblBorder">
                <xsl:call-template name="props">
                  <xsl:with-param name="outputstring" select="concat($outputstring,' border-',$check[$index],': ',string(number(($tblBorder/@w:sz,'0')[1]) div 8),'pt ',$border_html[fn:index-of($border_word,$tblBorder/@w:val)],' #',replace($tblBorder/@w:color,'auto','000000'),';')"/>
                  <xsl:with-param name="index" select="$index+1"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="props">
                  <xsl:with-param name="outputstring" select="concat($outputstring,' border-',$check[$index],': 0pt none #000000;')"/>
                  <xsl:with-param name="index" select="$index+1"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="$check[$index]='background'">
        <!-- controleer of w:tc een achtergrond heeft -->
        <xsl:variable name="tcBackground" select="w:tcPr/w:shd/@w:fill"/>
        <xsl:choose>
          <xsl:when test="$tcBackground">
            <xsl:call-template name="props">
              <xsl:with-param name="outputstring" select="concat($outputstring,' background-color: #',$tcBackground,';')"/>
              <xsl:with-param name="index" select="$index+1"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <!-- controleer of w:tbl een achtergrond heeft -->
            <xsl:variable name="tblLook" select="ancestor::w:tbl[1]/w:tblPr/w:tblLook"/>
            <xsl:variable name="tcLook" select="(ancestor::w:tr[1]/w:trPr/w:cnfStyle,self::w:tc[1]/w:tcPr/w:cnfStyle)[1]"/>
            <xsl:variable name="cnfStyle">
              <w:tcStylePr w:type="firstRow"><xsl:value-of select="$tblLook/@w:firstRow and sum($tcLook/@w:firstRow)"/></w:tcStylePr>
              <w:tcStylePr w:type="lastRow"><xsl:value-of select="$tblLook/@w:lastRow and sum($tcLook/@w:lastRow)"/></w:tcStylePr>
              <w:tcStylePr w:type="firstCol"><xsl:value-of select="$tblLook/@w:firstColumn and sum($tcLook/@w:firstColumn)"/></w:tcStylePr>
              <w:tcStylePr w:type="lastCol"><xsl:value-of select="$tblLook/@w:lastColumn and sum($tcLook/@w:lastColumn)"/></w:tcStylePr>
              <w:tcStylePr w:type="band1Vert"><xsl:value-of select="$tblLook/@w:noVBand and sum($tcLook/@w:oddVBand)"/></w:tcStylePr>
              <w:tcStylePr w:type="band1Horz"><xsl:value-of select="$tblLook/@w:noHBand and sum($tcLook/@w:oddHBand)"/></w:tcStylePr>
            </xsl:variable>
            <xsl:variable name="tblBackground" select="$style/w:tblStylePr[@w:type=$cnfStyle/element()[.=true()]/@w:type[1]]/w:tcPr/w:shd/@w:fill"/>
            <xsl:choose>
              <xsl:when test="$tblBackground">
                <xsl:call-template name="props">
                  <xsl:with-param name="outputstring" select="concat($outputstring,' background-color: #',$tblBackground,';')"/>
                  <xsl:with-param name="index" select="$index+1"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="props">
                  <xsl:with-param name="outputstring" select="concat($outputstring,' background-color: none;')"/>
                  <xsl:with-param name="index" select="$index+1"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="normalize-space($outputstring)"/>
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

  <xsl:template match="w:p/w:r/w:drawing">
    <xsl:variable name="id" select="generate-id(.)"/>
    <xsl:variable name="image" select="$TOF/image[@id=$id]"/>
    <xsl:choose>
      <xsl:when test="$image/@imageId!=''">
        <xsl:variable name="imageName" select="document($relations,.)//element()[@Id=$image/@imageId]/@Target"/>
        <xsl:variable name="width">
          <xsl:variable name="sum" select="(wp:anchor/wp:extent|wp:inline/a:graphic/a:graphicData/pic:pic/pic:spPr/a:xfrm/a:ext)[1]/@cx div 6.35 div (ancestor::w:tc[1]/w:tcPr/w:tcW/@w:w,preceding::w:sectPr[1]/(w:pgSz/@w:w - w:pgMar/@w:left - w:pgMar/@w:right))[1]"/>
          <xsl:choose>
            <xsl:when test="$sum lt 90">
              <xsl:value-of select="$sum * $scale"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="100"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:element name="img">
          <xsl:attribute name="src" select="$imageName"/>
          <xsl:attribute name="alt" select="$imageName"/>
          <xsl:attribute name="style" select="concat('width: ',$width,'%;')"/>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- textbox toevoegen -->

  <xsl:template match="w:txbxContent">
    <xsl:element name="div">
      <xsl:attribute name="class" select="string('textbox')"/>
      <xsl:call-template name="group_adjacent">
        <xsl:with-param name="group" select="node()"/>
      </xsl:call-template>
    </xsl:element>
  </xsl:template>

  <xsl:template match="mc:Fallback">
    <!-- gebruik mc:Choice en negeer mc:Fallback -->
  </xsl:template>

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

  <!-- functies -->

  <!-- functie om w:pPr van de alinea en van toegepaste opmaakprofielen te 'resolven' in één w:pPr -->
  <xsl:function name="w:pPr">
    <xsl:param name="w:p"/>
    <xsl:variable name="styleId" select="$w:p/w:pPr/w:pStyle/@w:val"/>
    <xsl:variable name="style" select="document($styles)/w:styles/w:style[@w:styleId=$styleId]"/>
    <xsl:sequence select="$w:p/w:pPr|$style[w:name]|$style/w:pPr"/>
  </xsl:function>

  <!-- functie om w:lvl van de alinea te 'resolven' -->
  <!-- deze functie heeft als invoer het resultaat van w:pPr(w:p)/w:numPr -->
  <xsl:function name="w:lvl">
    <xsl:param name="w:numPr"/>
    <xsl:variable name="abstractNumId" select="document($numbering)/w:numbering/w:num[@w:numId=$w:numPr/w:numId/@w:val]/w:abstractNumId/@w:val"/>
    <xsl:variable name="abstractNum" select="document($numbering)/w:numbering/w:abstractNum[@w:abstractNumId=$abstractNumId]"/>
    <xsl:sequence select="$abstractNum/w:lvl[@w:ilvl=($w:numPr/w:ilvl/@w:val,'0')[1]]"/>
  </xsl:function>

  <!-- functie om imageId van een w:drawing op te vragen -->
  <xsl:function name="w:imageId">
    <xsl:param name="w:drawing"/>
    <xsl:value-of select="$w:drawing//a:graphic/(descendant::asvg:svgBlip/@r:embed,descendant::a:blip/@r:embed,null)[1]"/>
  </xsl:function>

  <!-- functie om url's te uniformeren -->
  <!-- parameter url is een string of sequence of string -->
  <xsl:function name="my:url">
    <xsl:param name="url"/>
    <xsl:variable name="list" as="xs:string*">
      <xsl:for-each select="$url">
        <xsl:for-each select="fn:tokenize(.,$delimiter)[. ne '']">
          <xsl:value-of select="."/>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="fn:ends-with($list[1],':')">
        <!-- absoluut -->
        <xsl:choose>
          <xsl:when test="matches(fn:subsequence($list,3)[last()],'.+[\.][a-zA-Z]+[a-zA-Z0-9]+')">
            <!-- bestand -->
            <xsl:value-of select="fn:string-join(($list[1],'',fn:subsequence($list,2)),$delimiter)"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- map -->
            <xsl:value-of select="fn:string-join(($list[1],'',fn:subsequence($list,2),''),$delimiter)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- relatief -->
        <xsl:choose>
          <xsl:when test="matches($list[last()],'.+[\.][a-zA-Z]+[a-zA-Z0-9]+')">
            <!-- bestand -->
            <xsl:value-of select="fn:string-join($list,$delimiter)"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- map -->
            <xsl:value-of select="fn:string-join(($list,''),$delimiter)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

</xsl:stylesheet>