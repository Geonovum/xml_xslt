<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:key name="owFile" match="file" use="name"/>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    
    <!-- The Muenchian Method is usually the best method to use for grouping nodes together from the XML source to your output 
        because it doesn't involve trawling through large numbers of nodes, and it's therefore more efficient. 
        http://www.jenitennison.com/xslt/grouping/muenchian.html
        https://stackoverflow.com/questions/10912544/removing-duplicate-elements-with-xslt
    -->
    <xsl:template match="file[not(generate-id() = generate-id(key('owFile', name)[1]))]">
    </xsl:template>

</xsl:stylesheet>