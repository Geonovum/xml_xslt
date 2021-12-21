<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:my="http://www.eigen.nl">
  <xsl:output method="xhtml" encoding="UTF-8" indent="no"/>

  <xsl:param name="temp.dir" select="replace(fn:base-uri(),'respec/index.html','temp/')"/>

  <!-- scheidingsteken in paden -->
  <xsl:param name="delimiter" select="string('/')"/>

  <!-- verwijzingen naar gebruikte documenten -->
  <xsl:param name="config" select="fn:string-join(($temp.dir,'config.xml'),$delimiter)"/>

  <!-- options -->
  <xsl:param name="options" select="document('options.xml')/respec"/>

  <!-- respec -->
  <xsl:param name="respec">
    <xsl:copy-of select="document($config)/config/item[1]/node()"/>
  </xsl:param>

  <!-- snapshot -->
  <xsl:param name="snapshot">
    <xsl:copy-of select="document($config)/config/item[3]/node()"/>
  </xsl:param>

  <!-- title -->
  <xsl:param name="title" select="html/head/title"/>

  <!-- langauge -->
  <xsl:param name="language" select="html/@lang"/>

  <!-- nummering -->

  <xsl:param name="TOC">
    <xsl:for-each select="//(h1|h2|h3|h4|h5)">
      <xsl:element name="heading">
        <xsl:attribute name="id" select="parent::section/@id"/>
        <xsl:attribute name="level" select="count(ancestor::section)"/>
        <xsl:element name="number">
          <xsl:for-each select="ancestor::section">
            <xsl:element name="item">
              <xsl:value-of select="count(.|preceding-sibling::section[@class='body'])"/>
            </xsl:element>
          </xsl:for-each>
        </xsl:element>
        <xsl:element name="text">
          <xsl:copy-of select="node()"/>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
  </xsl:param>

  <xsl:param name="TOF">
    <xsl:for-each select="//figure">
      <xsl:element name="image">
        <xsl:attribute name="id" select="generate-id(figcaption)"/>
        <xsl:element name="number">
          <!-- we gaan ervan uit dat figuren in het hele document doortellen -->
          <xsl:element name="label">
            <xsl:value-of select="string('Figuur ')"/>
          </xsl:element>
          <xsl:element name="item">
            <xsl:value-of select="count(.|preceding::img)"/>
          </xsl:element>
        </xsl:element>
        <xsl:element name="text">
          <xsl:copy-of select="figcaption/node()"/>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
  </xsl:param>
  
  <xsl:param name="TOT">
    <xsl:for-each select="//table">
      <xsl:element name="table">
        <xsl:attribute name="id" select="generate-id(caption)"/>
        <xsl:element name="number">
          <!-- we gaan ervan uit dat tabellen in het hele document doortellen -->
          <xsl:element name="label">
            <xsl:value-of select="string('Tabel ')"/>
          </xsl:element>
          <xsl:element name="item">
            <xsl:value-of select="count(.|preceding::table)"/>
          </xsl:element>
        </xsl:element>
        <xsl:element name="text">
          <xsl:copy-of select="caption/node()"/>
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
          <xsl:value-of select="my:url('http://xmlns.com/foaf/0.1')"/>
        </xsl:element>
        <xsl:element name="datePublished">
          <xsl:element name="keyword">
            <xsl:attribute name="name" select="string('@type')"/>
            <xsl:value-of select="my:url('http://www.w3.org/2001/XMLSchema#date')"/>
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
        <xsl:value-of select="$snapshot/company/name"/>
      </xsl:element>
      <xsl:element name="url">
        <xsl:value-of select="my:url($snapshot/company/url)"/>
      </xsl:element>
    </xsl:element>
    <xsl:element name="discussionUrl">
      <xsl:value-of select="my:url($respec/issueBase)"/>
    </xsl:element>
    <xsl:element name="alternativeHeadline">
      <xsl:value-of select="$respec/subtitle"/>
    </xsl:element>
    <xsl:element name="isBasedOn">
      <xsl:value-of select="concat(my:url($snapshot/company/docs),'/',$respec/pubDomain,'/',fn:string-join((lower-case(fn:substring-after($respec/previousMaturity,'GN-')),$respec/shortName,fn:format-date($respec/previousPublishDate,'[Y0001][M01][D01]')),'-'))"/>
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

  <xsl:template match="head">
    <xsl:apply-templates select="meta"/>
    <xsl:apply-templates select="$title"/>
    <xsl:element name="link">
      <xsl:attribute name="rel" select="string('stylesheet')"/>
      <xsl:attribute name="type" select="string('text/css')"/>
      <xsl:attribute name="href" select="concat(my:url($snapshot/company/tools),'/respec/style/',$respec/specStatus,'.css')"/>
    </xsl:element>
    <xsl:element name="link">
      <xsl:attribute name="rel" select="string('stylesheet')"/>
      <xsl:attribute name="type" select="string('text/css')"/>
      <xsl:attribute name="href" select="string('css/style.css')"/>
    </xsl:element>
    <xsl:element name="link">
      <xsl:attribute name="rel" select="string('shortcut icon')"/>
      <xsl:attribute name="type" select="string('image/x-icon')"/>
      <xsl:attribute name="href" select="concat(my:url($snapshot/company/tools),'/respec/style/logos/',$snapshot/company/name,'.svg')"/>
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
  </xsl:template>

  <xsl:template match="body">
    <xsl:element name="{name()}">
      <xsl:apply-templates select="@*"/>
      <!-- plaats div head -->
      <xsl:call-template name="head"/>
      <!-- plaats nav -->
      <xsl:call-template name="nav"/>
      <!-- plaats body -->
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="body/link">
    <!-- doe niets -->
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
        <xsl:attribute name="href" select="my:url($snapshot/company/url)"/>
        <xsl:element name="img">
          <xsl:attribute name="id" select="$snapshot/company/name"/>
          <xsl:attribute name="alt" select="$snapshot/company/name"/>
          <xsl:attribute name="width" select="string('132')"/>
          <xsl:attribute name="height" select="string('67')"/>
          <xsl:attribute name="src" select="concat(my:url($snapshot/company/tools),'/respec/style/logos/',$snapshot/company/name,'.svg')"/>
        </xsl:element>
      </xsl:element>
      <xsl:element name="h1">
        <xsl:attribute name="class" select="string('title p-name')"/>
        <xsl:attribute name="id" select="string('title')"/>
        <xsl:value-of select="$title"/>
      </xsl:element>
      <xsl:element name="h2">
        <xsl:value-of select="$snapshot/company/name"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$options/list[@id='specType']/item[@id=$respec/specType]"/>
        <xsl:text disable-output-escaping="yes">&lt;br/&gt;</xsl:text>
        <xsl:value-of select="$respec/generatedSubtitle"/>
      </xsl:element>
      <xsl:element name="dl">
        <xsl:element name="dt">
          <xsl:text>Deze versie:</xsl:text>
        </xsl:element>
        <xsl:element name="dd">
          <xsl:element name="a">
            <xsl:attribute name="class" select="string('u-url')"/>
            <xsl:attribute name="href" select="concat(my:url($snapshot/company/docs),'/',$respec/pubDomain,'/',fn:string-join((lower-case(fn:substring-after($respec/specStatus,'GN-')),$respec/shortName,fn:format-date($respec/publishDate,'[Y0001][M01][D01]')),'-'))"/>
            <xsl:value-of select="concat(my:url($snapshot/company/docs),'/',$respec/pubDomain,'/',fn:string-join((lower-case(fn:substring-after($respec/specStatus,'GN-')),$respec/shortName,fn:format-date($respec/publishDate,'[Y0001][M01][D01]')),'-'))"/>
          </xsl:element>
        </xsl:element>
        <xsl:element name="dt">
          <xsl:text>Laatst gepubliceerde versie:</xsl:text>
        </xsl:element>
        <xsl:element name="dd">
          <xsl:element name="a">
            <xsl:attribute name="href" select="concat(my:url($snapshot/company/docs),'/',$respec/pubDomain,'/',$respec/shortName)"/>
            <xsl:value-of select="concat(my:url($snapshot/company/docs),'/',$respec/pubDomain,'/',$respec/shortName)"/>
          </xsl:element>
        </xsl:element>
        <xsl:if test="$respec/previousPublishDate">
          <xsl:element name="dt">
            <xsl:text>Vorige versie:</xsl:text>
          </xsl:element>
          <xsl:element name="dd">
            <xsl:element name="a">
              <xsl:attribute name="href" select="concat(my:url($snapshot/company/docs),'/',$respec/pubDomain,'/',fn:string-join((lower-case(fn:substring-after($respec/previousMaturity,'GN-')),$respec/shortName,fn:format-date($respec/previousPublishDate,'[Y0001][M01][D01]')),'-'))"/>
              <xsl:value-of select="concat(my:url($snapshot/company/docs),'/',$respec/pubDomain,'/',fn:string-join((lower-case(fn:substring-after($respec/previousMaturity,'GN-')),$respec/shortName,fn:format-date($respec/previousPublishDate,'[Y0001][M01][D01]')),'-'))"/>
            </xsl:element>
          </xsl:element>
        </xsl:if>
        <xsl:element name="dt">
          <xsl:text>Laatste werkversie:</xsl:text>
        </xsl:element>
        <xsl:element name="dd">
          <xsl:element name="a">
            <xsl:attribute name="href" select="my:url($respec/edDraftURI)"/>
            <xsl:value-of select="my:url($respec/edDraftURI)"/>
          </xsl:element>
        </xsl:element>
        <xsl:if test="$respec/editors/item">
          <xsl:element name="dt">
            <xsl:value-of select="if (count($respec/editors/item) eq 1) then 'Redacteur:' else 'Redacteurs:'"/>
            <xsl:for-each select="$respec/editors/item">
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
          </xsl:element>
        </xsl:if>
        <xsl:if test="$respec/authors/item">
          <xsl:element name="dt">
            <xsl:value-of select="if (count($respec/authors/item) eq 1) then 'Auteur:' else 'Auteurs:'"/>
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
          </xsl:element>
        </xsl:if>
        <xsl:if test="$respec/github">
          <xsl:element name="dt">
            <xsl:text>Doe mee:</xsl:text>
          </xsl:element>
          <xsl:element name="dd">
            <xsl:element name="a">
              <xsl:attribute name="href" select="my:url($respec/github)"/>
              <xsl:value-of select="replace(my:url($respec/github),'https://github.com/','GitHub ')"/>
            </xsl:element>
          </xsl:element>
          <xsl:element name="dd">
            <xsl:element name="a">
              <xsl:attribute name="href" select="my:url($respec/issueBase)"/>
              <xsl:text>Dien een melding in</xsl:text>
            </xsl:element>
          </xsl:element>
          <xsl:element name="dd">
            <xsl:element name="a">
              <xsl:attribute name="href" select="concat(my:url($respec/github),'/commits/gh-pages')"/>
              <xsl:text>Revisiehistorie</xsl:text>
            </xsl:element>
          </xsl:element>
          <xsl:element name="dd">
            <xsl:element name="a">
              <xsl:attribute name="href" select="concat(my:url($respec/github),'/pulls')"/>
              <xsl:text>Pull requests</xsl:text>
            </xsl:element>
          </xsl:element>
        </xsl:if>
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
                    <xsl:attribute name="src" select="concat(my:url($snapshot/company/tools),'/respec/style/logos/',$respec/license,'.svg')"/>
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
      <xsl:apply-templates select="." mode="nav"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="body" mode="nav">
    <xsl:element name="ol">
      <xsl:attribute name="class" select="string('toc')"/>
      <xsl:apply-templates select="section[@class='body']" mode="nav"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="section[@class='body']" mode="nav">
    <xsl:element name="li">
      <xsl:attribute name="class" select="string('tocline')"/>
      <xsl:apply-templates select="h1|h2|h3|h4|h5" mode="nav"/>
      <xsl:element name="ol">
        <xsl:attribute name="class" select="string('toc')"/>
        <xsl:apply-templates select="section[@class='body']" mode="nav"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="h1|h2|h3|h4|h5" mode="nav">
    <xsl:variable name="id" select="parent::section/@id"/>
    <xsl:variable name="heading" select="$TOC/heading[@id=$id]"/>
    <xsl:element name="a">
      <xsl:attribute name="class" select="string('tocxref')"/>
      <xsl:attribute name="href" select="concat('#',$id)"/>
      <xsl:element name="span">
        <xsl:attribute name="class" select="string('secno')"/>
        <xsl:value-of select="concat(fn:string-join($heading/number/item,'.'),' ')"/>
      </xsl:element>
      <xsl:apply-templates select="$heading/text" mode="nav"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="text" mode="nav">
    <xsl:apply-templates mode="nav"/>
  </xsl:template>

  <xsl:template match="a" mode="nav">
    <xsl:element name="span">
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="class" select="string('formerlink')"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*" mode="nav">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- alle koppen gaan één niveau omlaag -->

  <xsl:template match="section/h1">
    <xsl:variable name="id" select="parent::section/@id"/>
    <xsl:element name="h2">
      <xsl:apply-templates select="@*"/>
      <xsl:element name="span">
        <xsl:attribute name="class" select="string('secno')"/>
        <xsl:value-of select="concat(fn:string-join($TOC/heading[@id=$id]/number/item,'.'),'&#8194;')"/>
      </xsl:element>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="section/h2">
    <xsl:variable name="id" select="parent::section/@id"/>
    <xsl:element name="h3">
      <xsl:apply-templates select="@*"/>
      <xsl:element name="span">
        <xsl:attribute name="class" select="string('secno')"/>
        <xsl:value-of select="concat(fn:string-join($TOC/heading[@id=$id]/number/item,'.'),'&#8194;')"/>
      </xsl:element>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="section/h3">
    <xsl:variable name="id" select="parent::section/@id"/>
    <xsl:element name="h4">
      <xsl:apply-templates select="@*"/>
      <xsl:element name="span">
        <xsl:attribute name="class" select="string('secno')"/>
        <xsl:value-of select="concat(fn:string-join($TOC/heading[@id=$id]/number/item,'.'),'&#8194;')"/>
      </xsl:element>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="section/h4">
    <xsl:variable name="id" select="parent::section/@id"/>
    <xsl:element name="h5">
      <xsl:apply-templates select="@*"/>
      <xsl:element name="span">
        <xsl:attribute name="class" select="string('secno')"/>
        <xsl:value-of select="concat(fn:string-join($TOC/heading[@id=$id]/number/item,'.'),'&#8194;')"/>
      </xsl:element>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="section/h5">
    <xsl:variable name="id" select="parent::section/@id"/>
    <xsl:element name="h6">
      <xsl:apply-templates select="@*"/>
      <xsl:element name="span">
        <xsl:attribute name="class" select="string('secno')"/>
        <xsl:value-of select="concat(fn:string-join($TOC/heading[@id=$id]/number/item,'.'),'&#8194;')"/>
      </xsl:element>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="p[@class='heading6']">
    <xsl:element name="p">
      <xsl:attribute name="class" select="string('heading7')"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="p[@class='heading7']">
    <xsl:element name="{name()}">
      <xsl:attribute name="class" select="string('heading8')"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="p[@class='heading8']">
    <xsl:element name="{name()}">
      <xsl:attribute name="class" select="string('heading9')"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="p[@class='heading9']">
    <xsl:element name="{name()}">
      <xsl:attribute name="class" select="string('heading10')"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <!-- figuren -->

  <xsl:template match="figcaption">
    <xsl:variable name="id" select="generate-id(.)"/>
    <xsl:variable name="number" select="$TOF/image[@id=$id]/number"/>
    <xsl:element name="{name()}">
      <xsl:attribute name="id" select="$id"/>
      <xsl:value-of select="$number/label"/>
      <xsl:element name="span">
        <xsl:attribute name="class" select="string('figno')"/>
        <xsl:value-of select="fn:string-join($number/item,'.')"/>
      </xsl:element>
      <xsl:value-of select="string('&#8194;')"/>
      <xsl:element name="span">
        <xsl:attribute name="class" select="string('fig-title')"/>
        <xsl:apply-templates select="node()"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- tabellen -->

  <xsl:template match="caption">
    <xsl:variable name="id" select="generate-id(.)"/>
    <xsl:variable name="number" select="$TOT/table[@id=$id]/number"/>
    <xsl:element name="{name()}">
      <xsl:attribute name="id" select="$id"/>
      <xsl:value-of select="$number/label"/>
      <xsl:element name="span">
        <xsl:attribute name="class" select="string('tblno')"/>
        <xsl:value-of select="fn:string-join($number/item,'.')"/>
      </xsl:element>
      <xsl:value-of select="string('&#8194;')"/>
      <xsl:element name="span">
        <xsl:attribute name="class" select="string('tbl-title')"/>
        <xsl:apply-templates select="node()"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- algemeen -->

  <xsl:template match="element()">
    <xsl:element name="{name()}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="element()[@class='remove']">
    <!-- doe niets -->
  </xsl:template>

  <xsl:template match="@*">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="comment()">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="processing-instruction()">
    <xsl:copy-of select="."/>
  </xsl:template>

  <!-- functies -->

  <!-- functie om url's te uniformeren -->
  <xsl:function name="my:url">
    <xsl:param name="url"/>
    <xsl:variable name="list" select="fn:tokenize($url,'/')[. ne '']"/>
    <xsl:value-of select="fn:string-join(($list[1],'',fn:subsequence($list,2)),'/')"/>
  </xsl:function>

</xsl:stylesheet>