<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:bin="http://expath.org/ns/binary" xmlns:wx="http://schemas.microsoft.com/office/word/2006/auxHint" xmlns:ve="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:asvg="http://schemas.microsoft.com/office/drawing/2016/SVG/main">
  <xsl:output method="xhtml" encoding="UTF-8" indent="no"/>

  <xsl:param name="unzip.dir" select="fn:substring-before(fn:base-uri(),'word/document.xml')"/>

  <!-- scheidingsteken in paden -->
  <xsl:param name="delimiter" select="string('/')"/>

  <!-- verwijzingen naar gebruikte documenten -->
  <xsl:param name="comments" select="fn:string-join(($unzip.dir,'word','comments.xml'),$delimiter)"/>
  <xsl:param name="endnotes" select="fn:string-join(($unzip.dir,'word','endnotes.xml'),$delimiter)"/>
  <xsl:param name="footnotes" select="fn:string-join(($unzip.dir,'word','footnotes.xml'),$delimiter)"/>
  <xsl:param name="numbering" select="fn:string-join(($unzip.dir,'word','numbering.xml'),$delimiter)"/>
  <xsl:param name="relations" select="fn:string-join(($unzip.dir,'word','_rels','document.xml.rels'),$delimiter)"/>
  <xsl:param name="settings" select="fn:string-join(($unzip.dir,'word','settings.xml'),$delimiter)"/>
  <xsl:param name="styles" select="fn:string-join(($unzip.dir,'word','styles.xml'),$delimiter)"/>
  <xsl:param name="props" select="fn:string-join(($unzip.dir,'docProps','core.xml'),$delimiter)"/>

  <!-- title -->

  <xsl:param name="title">
    <xsl:value-of select="(document($settings,.)//w:docVar[@w:name='ID01']/@w:val,.//w:body/w:p[w:pPr(.)/w:name/@w:val='Title'][1],document($props,.)//dc:title)[1]"/>
  </xsl:param>

  <!-- mappings -->

  <xsl:param name="list_word" select="('bullet','decimal','upper-roman','lower-roman','upper-letter','lower-letter')"/>
  <xsl:param name="list_html" select="('ul','ol','ol','ol','ol','ol')"/>

  <xsl:param name="border_word" select="('single','dashDotStroked','dashed','dashSmallGap','dotDash','dotDotDash','dotted','double','doubleWave','inset','nil','none','outset','thick','thickThinLargeGap','thickThinMediumGap','thickThinSmallGap','thinThickLargeGap','thinThickMediumGap','thinThickSmallGap','thinThickThinLargeGap','thinThickThinMediumGap','thinThickThinSmallGap','threeDEmboss','threeDEngrave','triple','wave')"/>
  <xsl:param name="border_html" select="('solid','dashed','dashed','dashed','dashed','dashed','dotted','double','double','inset','none','none','outset','solid','dashed','dashed','dashed','dashed','dashed','dashed','dashed','dashed','dashed','ridge','groove','double','solid')"/>

  <!-- maak de inhoudsopgave -->

  <xsl:param name="tree">
    <xsl:element name="body">
      <xsl:attribute name="id" select="generate-id($title)"/>
      <xsl:attribute name="level" select="0"/>
      <xsl:element name="title">
        <xsl:apply-templates select="$title/node()"/>
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
    <xsl:for-each-group select="$group" group-starting-with="w:p[w:pPr(.)/w:name/@w:val=fn:format-number($level,'heading #')]">
      <xsl:choose>
        <xsl:when test="$level gt 6">
          <!-- stop -->
        </xsl:when>
        <xsl:when test="current-group()[1][w:pPr(.)/w:name/@w:val=fn:format-number($level,'heading #')]">
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
        <xsl:otherwise>
          <xsl:call-template name="tree">
            <xsl:with-param name="group" select="current-group()"/>
            <xsl:with-param name="level" select="$level+1"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>

  <xsl:variable name="TOC">
    <xsl:for-each select="$tree//title">
      <xsl:element name="title">
        <xsl:attribute name="id" select="parent::body/@id"/>
        <xsl:attribute name="level" select="parent::body/@level"/>
        <xsl:element name="text">
          <xsl:copy-of select="node()"/>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
    <xsl:for-each select="$tree//heading">
      <xsl:element name="heading">
        <xsl:attribute name="id" select="parent::section/@id"/>
        <xsl:attribute name="level" select="parent::section/@level"/>
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
          <xsl:apply-templates select="$TOC/title/text"/>
        </xsl:element>
        <xsl:element name="script">
          <xsl:attribute name="src" select="string('https://tools.geostandaarden.nl/respec/builds/respec-geonovum.js')"/>
        </xsl:element>
        <xsl:element name="script">
          <xsl:attribute name="src" select="string('js/config.js')"/>
        </xsl:element>
      </xsl:element>
      <xsl:apply-templates select="w:body"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="w:body">
    <xsl:element name="body">
      <!-- tijdelijke oplossing om style.css na base.css te laden -->
      <xsl:element name="link">
        <xsl:attribute name="rel" select="string('stylesheet')"/>
        <xsl:attribute name="type" select="string('text/css')"/>
        <xsl:attribute name="href" select="string('style.css')"/>
      </xsl:element>
      <!-- plaats verplichte samenvatting -->
      <xsl:element name="section">
        <xsl:attribute name="id" select="string('abstract')"/>
        <xsl:attribute name="class" select="string('remove')"/>
      </xsl:element>
      <!-- plaats verplichte sotd -->
      <xsl:element name="section">
        <xsl:attribute name="id" select="string('sotd')"/>
        <xsl:attribute name="class" select="string('remove')"/>
      </xsl:element>
      <!-- plaats inhoud -->
      <xsl:for-each-group select="element()" group-starting-with="w:p[w:pPr(.)/w:name/@w:val='heading 1'][1]">
        <xsl:choose>
          <xsl:when test="current-group()[1][w:pPr(.)/w:name/@w:val='heading 1']">
            <xsl:call-template name="section">
              <xsl:with-param name="group" select="current-group()"/>
              <xsl:with-param name="level" select="1"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <!-- negeer alles voor de eerste kop 1 -->
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each-group>
    </xsl:element>
  </xsl:template>

  <!-- groepeer elementen hiërarchisch -->

  <xsl:template name="section">
    <xsl:param name="group"/>
    <xsl:param name="level"/>
    <xsl:for-each-group select="$group" group-starting-with="w:p[w:pPr(.)/w:name/@w:val=fn:format-number($level,'heading #')]">
      <xsl:variable name="id" select="generate-id(.)"/>
      <xsl:choose>
        <xsl:when test="$level gt 6">
          <xsl:call-template name="group_adjacent">
            <xsl:with-param name="group" select="current-group()"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="current-group()[1][w:pPr(.)/w:name/@w:val=fn:format-number($level,'heading #')]">
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
          <xsl:call-template name="section">
            <xsl:with-param name="group" select="current-group()"/>
            <xsl:with-param name="level" select="$level+1"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each-group>
  </xsl:template>

  <!-- groepeer elementen niet-hiërarchisch -->

  <xsl:template name="group_adjacent">
    <xsl:param name="group"/>
    <xsl:for-each-group select="$group" group-adjacent="if (self::w:p[w:r/w:drawing]|self::w:p[w:pPr(.)/w:name/@w:val='caption'][preceding-sibling::w:p[1][w:r/w:drawing]]) then 'figuur' else if (self::w:tbl|self::w:p[w:pPr(.)/w:name/@w:val='caption'][following-sibling::element()[1][w:tbl]]) then 'tabel' else if (w:lvl(w:pPr(self::w:p)/w:numPr)[w:numFmt/@w:val=$list_word]) then 'lijst' else if (self::w:p[w:r/w:rPr/w:highlight/@w:val]) then fn:distinct-values(self::w:p/w:r/w:rPr/w:highlight/@w:val) else if (self::w:p[w:sdt/w:sdtPr/w14:checkbox]) then 'check' else 'standaard'">
      <xsl:choose>
        <xsl:when test="current-grouping-key()='figuur'">
          <xsl:for-each-group select="current-group()" group-ending-with="self::w:p[w:pPr(.)/w:name/@w:val='caption']">
            <xsl:element name="figure">
              <xsl:attribute name="id" select="generate-id(.)"/>
              <xsl:for-each select="current-group()">
                <xsl:choose>
                  <xsl:when test="self::w:p[w:r/w:drawing]">
                    <xsl:apply-templates select="./w:r/w:drawing"/>
                  </xsl:when>
                  <xsl:when test="self::w:p[w:pPr(.)/w:name/@w:val='caption']">
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
    <xsl:variable name="id" select="fn:string-join(w:pPr($group[1])/w:numPr/element()/@w:val)"/>
    <xsl:variable name="type" select="($list_html[fn:index-of($list_word,w:lvl(w:pPr($group[1])/w:numPr)/w:numFmt/@w:val)],'ul')[1]"/>
    <xsl:element name="{$type}">
      <xsl:for-each-group select="$group" group-starting-with="self::w:p[fn:string-join(w:pPr(.)/w:numPr/element()/@w:val)=$id]">
        <xsl:element name="li">
          <!-- verwerk geneste opsommingen -->
          <xsl:for-each-group select="current-group()" group-adjacent="if (fn:string-join(w:pPr(self::w:p)/w:numPr/element()/@w:val)=$id) then 'item' else 'lijst'">
            <xsl:choose>
              <xsl:when test="current-grouping-key() eq 'item'">
                <xsl:apply-templates select="current-group()[1]/self::w:p"/>
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
    <xsl:param name="id"/>
    <xsl:variable name="heading" select="$TOC/heading[@id eq $id]"/>
    <xsl:variable name="style" select="(w:pPr(.)/w:name/@w:val,'Normal')[1]"/>
    <xsl:choose>
      <xsl:when test="descendant::w:t|descendant::w:drawing">
        <xsl:choose>
          <xsl:when test="$heading">
            <xsl:element name="{concat('h',$heading/@level)}">
              <xsl:attribute name="id" select="concat('x',fn:string-join(($heading/number/item,$id),'-'))"/>
              <xsl:apply-templates select="node()"/>
            </xsl:element>
          </xsl:when>
          <xsl:when test="$style=('heading 7','heading 8','heading 9')">
            <xsl:element name="p">
              <xsl:attribute name="class" select="translate(lower-case($style),' ','')"/>
              <xsl:apply-templates select="node()"/>
            </xsl:element>
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
              <!-- plaats indentation, alleen van w:p -->
              <xsl:if test="self::w:p/w:pPr/w:ind/@w:left">
                <xsl:attribute name="style" select="concat('margin-left: ',fn:format-number(number(self::w:p/w:pPr/w:ind/@w:left) * 0.0176388889,'#.#'),'mm;')"/>
              </xsl:if>
              <xsl:apply-templates select="node()"/>
            </xsl:element>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!-- lege alinea -->
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
      <xsl:when test="fn:starts-with(./@w:name,'_')">
        <!-- doe niets, hidden bookmark -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="a">
          <xsl:attribute name="name" select="@w:name"/>
        </xsl:element>
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

  <!--routine om elementen in w:rPr af te splitsen-->
  <xsl:template name="range">
    <xsl:param name="node"/>
    <xsl:param name="index"/>
    <xsl:choose>
      <xsl:when test="w:rPr/*[$index]">
        <xsl:choose>
          <xsl:when test="name($node/w:rPr/*[$index])='w:rStyle'">
            <xsl:variable name="styleId" select="$node/w:rPr/w:rStyle/@w:val"/>
            <xsl:variable name="styleName" select="document($styles,.)/w:styles/w:style[@w:styleId=$styleId]/w:name/@w:val"/>
            <!-- hier kan een choose op basis van styleName -->
            <xsl:call-template name="range">
              <xsl:with-param name="node" select="$node"/>
              <xsl:with-param name="index" select="$index+1"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="name($node/w:rPr/*[$index])='w:highlight'">
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
          <xsl:when test="name($node/w:rPr/*[$index])='w:color'">
            <xsl:element name="span">
              <xsl:attribute name="style" select="concat('color: #',$node/w:rPr/w:color/@w:val,';')"/>
              <xsl:call-template name="range">
                <xsl:with-param name="node" select="$node"/>
                <xsl:with-param name="index" select="$index+1"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:when>
          <!--xsl:when test="name(w:rPr/*[$index]) = 'w:rFonts'">
            <xsl:call-template name="range">
              <xsl:with-param name="node" select="$node"/>
              <xsl:with-param name="index" select="$index+1"/>
            </xsl:call-template>
          </xsl:when-->
          <xsl:when test="name($node/w:rPr/*[$index])='w:b'">
            <xsl:element name="b">
              <xsl:call-template name="range">
                <xsl:with-param name="node" select="$node"/>
                <xsl:with-param name="index" select="$index+1"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:when>
          <xsl:when test="name($node/w:rPr/*[$index])='w:i'">
            <xsl:element name="i">
              <xsl:call-template name="range">
                <xsl:with-param name="node" select="$node"/>
                <xsl:with-param name="index" select="$index+1"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:when>
          <xsl:when test="name($node/w:rPr/*[$index])='w:u'">
            <xsl:element name="u">
              <xsl:call-template name="range">
                <xsl:with-param name="node" select="$node"/>
                <xsl:with-param name="index" select="$index+1"/>
              </xsl:call-template>
            </xsl:element>
          </xsl:when>
          <xsl:when test="name($node/w:rPr/*[$index])='w:vertAlign'">
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
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- velden bewerken -->

  <xsl:template match="w:instrText">
    <!-- tekst niet plaatsen -->
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
    <xsl:variable name="cols" select="w:tblGrid/w:gridCol"/>
    <xsl:variable name="tablewidth" select="sum($cols/@w:w)"/>
    <xsl:element name="table">
      <xsl:attribute name="style" select="if ($tablewidth gt 6500) then string('width: 100%;') else concat('width: ',string($tablewidth div 20),'pt;')"/>
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
        <xsl:with-param name="group" select="*"/>
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

  <!-- routine om margin te testen -->
  <xsl:template name="margin">
    <xsl:param name="check"/>
    <!-- controleer of w:tc een marge heeft -->
    <xsl:variable name="tcMar" select="w:tcPr/w:tcMar/*[name()=concat('w:', $check)]/@w:w"/>
    <xsl:choose>
      <xsl:when test="$tcMar">
        <xsl:value-of select="concat(string(number($tcMar) div 20), 'pt')"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- controleer of w:tbl een marge heeft -->
        <xsl:variable name="tblCellMar" select="ancestor::w:tbl[1]/w:tblPr/w:tblCellMar/*[name()=concat('w:', $check)]/@w:w"/>
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
        <xsl:variable name="tcBorder" select="w:tcPr/w:tcBorders/*[local-name()=$check[$index]]"/>
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
        <xsl:variable name="tcBorder" select="w:tcPr/w:tcBorders/*[name()=concat('w:',$check[$index])]"/>
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
            <xsl:variable name="tblBackground" select="$style/w:tblStylePr[@w:type=$cnfStyle/*[.=true()]/@w:type[1]]/w:tcPr/w:shd/@w:fill"/>
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

  <xsl:template match="w:drawing">
    <xsl:variable name="imageId" select=".//a:graphic/(descendant::asvg:svgBlip/@r:embed,descendant::a:blip/@r:embed)[1]"/>
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
          <xsl:attribute name="style" select="concat('width: ',$width,';')"/>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

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
    <xsl:sequence select="$abstractNum/w:lvl[@w:ilvl=$w:numPr/w:ilvl/@w:val]"/>
  </xsl:function>

</xsl:stylesheet>