<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="2.0">

  <!--
    Adler-32 checksum algorithm implementation in XSLT 2.0.
    
    See <a href="http://en.wikipedia.org/wiki/Adler-32">link</a>
    
    Gist: <a href="https://gist.github.com/aleksandr-vin/dfbdc71a9028785bac3a#file-adler32-xslt">adler32-xslt</a>
    
    Downdload: wget &#8211;-no-check-certificate https://gist.github.com/aleksandr-vin/dfbdc71a9028785bac3a/raw/adler32.xslt
    
    Example:
    <xsl:call-template name="adler32">
      <xsl:with-param name="text">Wikipedia</xsl:with-param>
    </xsl:call-template>
  -->

  <xsl:template name="adler32">
    <xsl:param name="text"/>
    <xsl:param name="A">1</xsl:param>
    <xsl:param name="B">0</xsl:param>
    <xsl:choose>
      <xsl:when test="not('' = $text)">
        <xsl:variable name="Ai">
          <xsl:value-of select="$A + string-to-codepoints(substring($text,1,1))"/>
        </xsl:variable>
        <xsl:variable name="Bi">
          <xsl:value-of select="$B + $Ai"/>
        </xsl:variable>
        <xsl:call-template name="adler32">
          <xsl:with-param name="text">
            <xsl:value-of select="substring($text,2)"/>
          </xsl:with-param>
          <xsl:with-param name="A">
            <xsl:value-of select="$Ai mod 65521"/>
          </xsl:with-param>
          <xsl:with-param name="B">
            <xsl:value-of select="$Bi mod 65521"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="format-number($B * 65536 + $A, '##########')" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>