<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:ft="http://marekbostik.cz/filmoteka"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="ft xs">

    <xsl:output method="xml" indent="yes"/>
    
    <xsl:variable name="ramecek">0.5pt solid black</xsl:variable>

    <xsl:template match="/">
        <fo:root font-family="Arial, sans-serif">
            
            <fo:layout-master-set>
                <fo:simple-page-master master-name="Titulka" page-height="29.7cm" page-width="21cm" margin="2cm">
                    <fo:region-body margin-top="8cm"/>
                </fo:simple-page-master>

                <fo:simple-page-master master-name="StrankaA4" page-height="29.7cm" page-width="21cm" margin="2cm">
                    <fo:region-body margin-top="2.5cm" margin-bottom="2cm"/>
                    <fo:region-before extent="2cm"/>
                    <fo:region-after extent="1.5cm"/>
                </fo:simple-page-master>
            </fo:layout-master-set>

            <fo:page-sequence master-reference="Titulka">
                <fo:flow flow-name="xsl-region-body">
                    <fo:block text-align="center" font-size="36pt" font-weight="bold" color="#2c3e50" space-after="20pt">
                        FILMOTÉKA
                    </fo:block>
                    <fo:block text-align="center" font-size="16pt" color="grey" space-after="40pt">
                        Semestrální práce 4IZ238
                    </fo:block>
                    
                    <fo:block text-align="center" border-top="1pt solid black" border-bottom="1pt solid black" padding="20pt" margin-left="2cm" margin-right="2cm">
                        <fo:block font-weight="bold" space-after="5pt">
                            Autor: <xsl:value-of select="ft:filmoteka/@majitel"/>
                        </fo:block>
                        <fo:block space-after="5pt">
                            Datum vytvoření: <xsl:value-of select="ft:filmoteka/@vytvoreno"/>
                        </fo:block>
                        <fo:block>
                            Celkem položek: <xsl:value-of select="count(//ft:film | //ft:serial)"/>
                        </fo:block>
                    </fo:block>
                </fo:flow>
            </fo:page-sequence>

            <fo:page-sequence master-reference="StrankaA4">
                
                <fo:static-content flow-name="xsl-region-before">
                    <fo:block text-align="right" font-size="10pt" color="grey" border-bottom="1pt solid black">
                        Katalog filmů a seriálů
                    </fo:block>
                </fo:static-content>
                
                <fo:static-content flow-name="xsl-region-after">
                    <fo:block text-align="center" font-size="10pt" border-top="1pt solid black" padding-top="5pt">
                        Strana <fo:page-number/>
                    </fo:block>
                </fo:static-content>

                <fo:flow flow-name="xsl-region-body">
                    
                    <fo:block font-size="18pt" font-weight="bold" border-bottom="2pt solid black" space-after="15pt">
                        Obsah
                    </fo:block>
                    
                    <xsl:for-each select="//ft:film | //ft:serial">
                        <xsl:sort select="ft:nazvy/ft:cesky"/>
                        <fo:block text-align-last="justify" margin-bottom="5pt" font-size="11pt">
                            <fo:basic-link internal-destination="{@id}">
                                <xsl:value-of select="ft:nazvy/ft:cesky"/>
                                <xsl:if test="local-name()='serial'">
                                    <fo:inline font-size="0.8em" font-style="italic"> (Seriál)</fo:inline>
                                </xsl:if>
                                <fo:leader leader-pattern="dots"/>
                                <fo:page-number-citation ref-id="{@id}"/>
                            </fo:basic-link>
                        </fo:block>
                    </xsl:for-each>

                    <fo:block break-before="page"/>

                    <fo:block font-size="16pt" font-weight="bold" space-after="10pt">Přehled hodnocení</fo:block>
                    
                    <fo:table table-layout="fixed" width="100%" border="{$ramecek}">
                        <fo:table-column column-width="50%"/>
                        <fo:table-column column-width="25%"/>
                        <fo:table-column column-width="25%"/>
                        
                        <fo:table-header>
                            <fo:table-row background-color="#eee" font-weight="bold">
                                <fo:table-cell padding="5pt" border="{$ramecek}"><fo:block>Název</fo:block></fo:table-cell>
                                <fo:table-cell padding="5pt" border="{$ramecek}"><fo:block>Rok</fo:block></fo:table-cell>
                                <fo:table-cell padding="5pt" border="{$ramecek}"><fo:block>Hodnocení</fo:block></fo:table-cell>
                            </fo:table-row>
                        </fo:table-header>
                        
                        <fo:table-body>
                            <xsl:for-each select="//ft:film | //ft:serial">
                                <xsl:sort select="ft:hodnoceni/ft:osobni" order="descending" data-type="number"/>
                                <fo:table-row>
                                    <fo:table-cell padding="5pt" border="{$ramecek}">
                                        <fo:block><xsl:value-of select="ft:nazvy/ft:cesky"/></fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell padding="5pt" border="{$ramecek}">
                                        <fo:block><xsl:value-of select="ft:rok"/></fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell padding="5pt" border="{$ramecek}">
                                        <fo:block font-weight="bold">
                                            <xsl:choose>
                                                <xsl:when test="ft:hodnoceni/ft:osobni &gt;= 8"><xsl:attribute name="color">green</xsl:attribute></xsl:when>
                                                <xsl:when test="ft:hodnoceni/ft:osobni &lt; 6"><xsl:attribute name="color">red</xsl:attribute></xsl:when>
                                                <xsl:otherwise><xsl:attribute name="color">black</xsl:attribute></xsl:otherwise>
                                            </xsl:choose>
                                            <xsl:value-of select="ft:hodnoceni/ft:osobni"/>/10
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </xsl:for-each>
                        </fo:table-body>
                    </fo:table>

                    <xsl:for-each select="//ft:film | //ft:serial">
                        <fo:block break-before="page" id="{@id}">
                            
                            <fo:block font-size="22pt" font-weight="bold" border-bottom="2pt solid black" space-after="5pt">
                                <xsl:value-of select="ft:nazvy/ft:cesky"/>
                            </fo:block>
                            
                            <fo:table width="100%">
                                <fo:table-column column-width="35%"/>
                                <fo:table-column column-width="65%"/>
                                <fo:table-body>
                                    <fo:table-row>
                                        <fo:table-cell padding-right="15pt">
                                            <fo:block space-after="10pt">
                                                <xsl:if test="ft:multimedia/ft:obrazek[@typ='obal_predni']">
                                                    <fo:external-graphic src="{ft:multimedia/ft:obrazek[@typ='obal_predni']}" content-width="scale-to-fit" width="100%"/>
                                                </xsl:if>
                                            </fo:block>
                                            
                                            <fo:block border="1pt solid grey" padding="8pt" background-color="#f5f5f5">
                                                <fo:block font-weight="bold" border-bottom="1pt solid grey" margin-bottom="5pt">HODNOCENÍ</fo:block>
                                                <fo:block>Osobní: <fo:inline font-weight="bold"><xsl:value-of select="ft:hodnoceni/ft:osobni"/>/10</fo:inline></fo:block>
                                                <fo:block>IMDb: <xsl:value-of select="ft:hodnoceni/ft:imdb"/></fo:block>
                                                <xsl:if test="ft:hodnoceni/ft:csfd">
                                                    <fo:block>ČSFD: <xsl:value-of select="ft:hodnoceni/ft:csfd"/>%</fo:block>
                                                </xsl:if>
                                            </fo:block>
                                        </fo:table-cell>
                                        
                                        <fo:table-cell>
                                            <fo:block font-style="italic" color="grey" space-after="10pt">
                                                <xsl:value-of select="ft:nazvy/ft:originalni"/>
                                            </fo:block>

                                            <fo:block font-weight="bold">Anotace:</fo:block>
                                            <fo:block text-align="justify" space-after="10pt">
                                                <xsl:value-of select="ft:anotace"/>
                                            </fo:block>

                                            <fo:block font-weight="bold" background-color="#eee" padding="2pt">Technické info:</fo:block>
                                            <fo:block margin-left="5pt" space-after="10pt" font-size="9pt">
                                                <fo:block>Rok: <xsl:value-of select="ft:rok"/></fo:block>
                                                <fo:block>Délka: <xsl:value-of select="ft:delka"/> min</fo:block>
                                                <fo:block>Formát: <xsl:value-of select="ft:format/ft:nosic"/> (<xsl:value-of select="ft:format/ft:edice"/>)</fo:block>
                                            </fo:block>

                                            <fo:block font-weight="bold" background-color="#eee" padding="2pt">Lokalizace:</fo:block>
                                            <fo:block margin-left="5pt" space-after="10pt" font-size="9pt">
                                                <fo:block>Zvuk: 
                                                    <xsl:for-each select="ft:lokalizace/ft:stopa">
                                                        <xsl:value-of select="."/> (<xsl:value-of select="@typ"/>)<xsl:if test="position()!=last()">, </xsl:if>
                                                    </xsl:for-each>
                                                </fo:block>
                                                <xsl:if test="ft:lokalizace/ft:titulky">
                                                    <fo:block>Titulky: 
                                                        <xsl:for-each select="ft:lokalizace/ft:titulky/ft:titulek">
                                                            <xsl:value-of select="."/><xsl:if test="position()!=last()">, </xsl:if>
                                                        </xsl:for-each>
                                                    </fo:block>
                                                </xsl:if>
                                            </fo:block>

                                            <fo:block font-weight="bold" background-color="#eee" padding="2pt" space-after="5pt">Tvůrci a obsazení:</fo:block>
                                            
                                            <fo:table width="100%" font-size="9pt" border-collapse="collapse">
                                                <fo:table-column column-width="50%"/>
                                                <fo:table-column column-width="50%"/>
                                                <fo:table-body>
                                                    <xsl:for-each-group select="ft:osoby/ft:osoba" group-by="@role">
                                                        
                                                        <fo:table-row background-color="#f0f0f0">
                                                            <fo:table-cell number-columns-spanned="2" padding="3pt" border-bottom="0.5pt solid black">
                                                                <fo:block font-weight="bold" font-style="italic" color="#0056b3">
                                                                    <xsl:choose>
                                                                        <xsl:when test="current-grouping-key()='reziser'">Režie</xsl:when>
                                                                        <xsl:when test="current-grouping-key()='scenarista'">Scénář</xsl:when>
                                                                        <xsl:when test="current-grouping-key()='herec'">Hrají</xsl:when>
                                                                        <xsl:when test="current-grouping-key()='kameraman'">Kamera</xsl:when>
                                                                        <xsl:when test="current-grouping-key()='skladatel'">Hudba</xsl:when>
                                                                        <xsl:when test="current-grouping-key()='showrunner'">Showrunner</xsl:when>
                                                                        <xsl:otherwise><xsl:value-of select="current-grouping-key()"/></xsl:otherwise>
                                                                    </xsl:choose>
                                                                </fo:block>
                                                            </fo:table-cell>
                                                        </fo:table-row>

                                                        <xsl:for-each select="current-group()">
                                                            <fo:table-row border-bottom="0.5pt dashed #ccc">
                                                                <fo:table-cell padding="2pt" padding-left="10pt">
                                                                    <fo:block>
                                                                        <xsl:value-of select="ft:jmeno"/>&#160;<xsl:value-of select="ft:prijmeni"/>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                                <fo:table-cell padding="2pt">
                                                                    <fo:block font-style="italic" color="#555">
                                                                        <xsl:if test="@postava">
                                                                            <xsl:value-of select="@postava"/>
                                                                        </xsl:if>
                                                                    </fo:block>
                                                                </fo:table-cell>
                                                            </fo:table-row>
                                                        </xsl:for-each>
                                                    </xsl:for-each-group>
                                                </fo:table-body>
                                            </fo:table>
                                            
                                            <xsl:if test="ft:poznamka">
                                                <fo:block margin-top="15pt" font-size="9pt" border="1pt dotted grey" padding="5pt">
                                                    <fo:inline font-weight="bold">Pozn.: </fo:inline>
                                                    <xsl:value-of select="ft:poznamka"/>
                                                </fo:block>
                                            </xsl:if>

                                        </fo:table-cell>
                                    </fo:table-row>
                                </fo:table-body>
                            </fo:table>
                        </fo:block>
                    </xsl:for-each>

                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>
</xsl:stylesheet>