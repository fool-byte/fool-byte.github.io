<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ft="http://marekbostik.cz/filmoteka"
    xmlns:my="http://marekbostik.cz/funkce"
    exclude-result-prefixes="xs ft my">

    <xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes"/>
    
    <xsl:param name="stranka-nazev" select="'Filmotéka - Semestrální práce'"/>

    <xsl:function name="my:ziskej-barvu">
        <xsl:param name="hodnota"/>
        <xsl:choose>
            <xsl:when test="$hodnota &gt;= 8">#d4edda</xsl:when> <xsl:when test="$hodnota &gt;= 6">#fff3cd</xsl:when> <xsl:otherwise>#f8d7da</xsl:otherwise>         </xsl:choose>
    </xsl:function>

    <xsl:template match="/">
        <xsl:call-template name="html-kostra">
            <xsl:with-param name="titulek" select="$stranka-nazev"/>
            <xsl:with-param name="obsah">
                
                <div class="hlavicka">
                    <h1><xsl:value-of select="$stranka-nazev"/></h1>
                    <p>Majitel sbírky: <strong><xsl:value-of select="ft:filmoteka/@majitel"/></strong></p>
                </div>

                <nav class="obsah-toc">
                    <h2>Rychlý přehled titulů</h2>
                    <ul>
                        <xsl:for-each select="//ft:film | //ft:serial">
                            <xsl:sort select="ft:nazvy/ft:cesky"/>
                            <li>
                                <a href="detail-{@id}.html">
                                    <xsl:value-of select="ft:nazvy/ft:cesky"/>
                                    <small> (<xsl:value-of select="ft:rok"/>)</small>
                                    
                                    <xsl:if test="local-name()='serial'">
                                        <span class="toc-stit">Seriál</span>
                                    </xsl:if>
                                </a>
                            </li>
                        </xsl:for-each>
                    </ul>
                </nav>

                <div class="kontejner">
                    <xsl:for-each select="//ft:film | //ft:serial">
                        <xsl:sort select="ft:hodnoceni/ft:osobni" order="descending" data-type="number"/>
                        
                        <div class="karta">
                            <div class="karta-hlavicka">
                                <xsl:attribute name="style">
                                    background-color: <xsl:value-of select="my:ziskej-barvu(ft:hodnoceni/ft:osobni)"/>
                                </xsl:attribute>
                                
                                <span><xsl:value-of select="ft:hodnoceni/ft:osobni"/>/10</span>
                                <xsl:if test="local-name()='serial'">
                                    <span class="stit-serial">SERIÁL</span>
                                </xsl:if>
                            </div>
                            
                            <div class="karta-obsah">
                                <h3><xsl:value-of select="ft:nazvy/ft:cesky"/></h3>
                                <p>Orig: <em><xsl:value-of select="ft:nazvy/ft:originalni"/></em></p>
                                <a href="detail-{@id}.html" class="tlacitko">Zobrazit detail</a>
                            </div>
                        </div>

                        <xsl:call-template name="generuj-detail-soubor"/>
                    </xsl:for-each>
                </div>

            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="generuj-detail-soubor">
        <xsl:result-document href="detail-{@id}.html">
            <xsl:call-template name="html-kostra">
                <xsl:with-param name="titulek" select="ft:nazvy/ft:cesky"/>
                <xsl:with-param name="obsah">
                    
                    <div class="menu-zpet">
                        <a href="index.html">← Zpět na seznam titulů</a>
                    </div>
                    
                    <article class="detail-obal">
                        <h1>
                            <xsl:value-of select="ft:nazvy/ft:cesky"/> 
                            <span style="font-weight:normal; font-size:0.6em; color:#777"> (<xsl:value-of select="ft:rok"/>)</span>
                        </h1>
                        
                        <div class="detail-sloupce">
                            <div class="sloupec-vlevo">
                                <xsl:if test="ft:multimedia/ft:obrazek[@typ='obal_predni']">
                                    <img src="{ft:multimedia/ft:obrazek[@typ='obal_predni']}" alt="Obal" class="velky-obrazek"/>
                                </xsl:if>

                                <div class="box-hodnoceni">
                                    <h3>Hodnocení</h3>
                                    <p><strong>Osobní: <xsl:value-of select="ft:hodnoceni/ft:osobni"/>/10</strong></p>
                                    <p>IMDb: <xsl:value-of select="ft:hodnoceni/ft:imdb"/></p>
                                    <xsl:if test="ft:hodnoceni/ft:csfd">
                                        <p>ČSFD: <xsl:value-of select="ft:hodnoceni/ft:csfd"/> %</p>
                                    </xsl:if>
                                </div>
                            </div>

                            <div class="sloupec-vpravo">
                                <p><strong>Originální název:</strong> <xsl:value-of select="ft:nazvy/ft:originalni"/></p>
                                <p>
                                    <strong>Žánry: </strong>
                                    <xsl:for-each select="ft:zanry/ft:zanr">
                                        <xsl:value-of select="."/><xsl:if test="position()!=last()">, </xsl:if>
                                    </xsl:for-each>
                                </p>
                                <p><em><xsl:value-of select="ft:anotace"/></em></p>

                                <h3>Technické parametry</h3>
                                <table class="tabulka-info">
                                    <tr><td>Délka:</td><td><xsl:value-of select="ft:delka"/> min</td></tr>
                                    <tr><td>Věkové omezení:</td><td><xsl:value-of select="ft:vekoveOmezeni"/>+</td></tr>
                                    <tr><td>Formát:</td><td><xsl:value-of select="ft:format/ft:nosic"/> (<xsl:value-of select="ft:format/ft:edice"/>)</td></tr>
                                    
                                    <tr>
                                        <td>Zvuk:</td>
                                        <td>
                                            <xsl:for-each select="ft:lokalizace/ft:stopa">
                                                <xsl:value-of select="."/> 
                                                <small>(<xsl:value-of select="@typ"/>)</small>
                                                <xsl:if test="position()!=last()">, </xsl:if>
                                            </xsl:for-each>
                                        </td>
                                    </tr>
                                    
                                    <xsl:if test="ft:lokalizace/ft:titulky/ft:titulek">
                                        <tr>
                                            <td>Titulky:</td>
                                            <td>
                                                <xsl:for-each select="ft:lokalizace/ft:titulky/ft:titulek">
                                                    <xsl:value-of select="."/>
                                                    <xsl:if test="position()!=last()">, </xsl:if>
                                                </xsl:for-each>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                </table>

                                <h3>Tvůrci a obsazení</h3>
                                <xsl:for-each-group select="ft:osoby/ft:osoba" group-by="@role">
                                    <div class="skupina-roli">
                                        <h4>
                                            <xsl:choose>
                                                <xsl:when test="current-grouping-key()='reziser'">Režie</xsl:when>
                                                <xsl:when test="current-grouping-key()='scenarista'">Scénář</xsl:when>
                                                <xsl:when test="current-grouping-key()='herec'">Hrají</xsl:when>
                                                <xsl:when test="current-grouping-key()='kameraman'">Kamera</xsl:when>
                                                <xsl:when test="current-grouping-key()='skladatel'">Hudba</xsl:when>
                                                <xsl:when test="current-grouping-key()='showrunner'">Showrunner</xsl:when>
                                                <xsl:otherwise><xsl:value-of select="current-grouping-key()"/></xsl:otherwise>
                                            </xsl:choose>
                                        </h4>
                                        <ul>
                                            <xsl:for-each select="current-group()">
                                                <li>
                                                    <xsl:value-of select="ft:jmeno"/>&#160;<xsl:value-of select="ft:prijmeni"/>
                                                    <xsl:if test="@postava"> (jako <xsl:value-of select="@postava"/>)</xsl:if>
                                                </li>
                                            </xsl:for-each>
                                        </ul>
                                    </div>
                                </xsl:for-each-group>
                                
                                <xsl:if test="ft:poznamka">
                                    <div class="poznamka">
                                        <strong>Poznámka:</strong> <xsl:value-of select="ft:poznamka"/>
                                    </div>
                                </xsl:if>

                            </div>
                        </div>
                    </article>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="html-kostra">
        <xsl:param name="titulek"/>
        <xsl:param name="obsah"/>
        
        <html lang="cs">
            <head>
                <meta charset="UTF-8"/>
                <title><xsl:value-of select="$titulek"/></title>
                <link rel="stylesheet" href="style.css" type="text/css"/>
            </head>
            <body>
                <xsl:copy-of select="$obsah"/>
                
                <div class="paticka">
                    &#169; 2024 Marek Boštík | Vygenerováno pomocí XSLT 2.0
                </div>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>