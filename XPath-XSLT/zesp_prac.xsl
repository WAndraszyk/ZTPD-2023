<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match='/'>
        <html>
            <head>
            </head>
            <body>
                <h1>ZESPOŁY:</h1>
                <ol>
                    <xsl:apply-templates mode="lista" select="ZESPOLY/ROW"/>
                </ol>
                <xsl:apply-templates mode="details" select="ZESPOLY/ROW"/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="*" mode="lista">
        <li>
            <a href="#{ID_ZESP}"> <xsl:value-of select="NAZWA"/> </a>
        </li>
    </xsl:template>
    <xsl:template match="*" mode="details">
        <h2 id="{ID_ZESP}">
            NAZWA: <xsl:value-of select="NAZWA"/>
            <br/>
            ADRES: <xsl:value-of select="ADRES"/>
        </h2>
        <xsl:choose>
            <xsl:when test="count(PRACOWNICY/ROW) > 0">
                <table border="1">
                    <tr><th>Nazwisko</th><th>Etat</th><th>Zatrudniony</th><th>Płaca pod.</th><th>Id szefa</th></tr>
                    <xsl:apply-templates mode="pracownicy" select="PRACOWNICY/ROW">
                        <xsl:sort select="NAZWISKO"/>
                    </xsl:apply-templates>
                </table>
            </xsl:when>
        </xsl:choose>
        Liczba pracowników: <xsl:value-of select="count(PRACOWNICY/ROW)"/>
    </xsl:template>
    <xsl:key name="pracownicyKey" match="ZESPOLY/ROW/PRACOWNICY/ROW" use="ID_PRAC"/>
    <xsl:template match="*" mode="pracownicy">
        <tr>
            <td><xsl:value-of select="NAZWISKO"/></td>
            <td><xsl:value-of select="ETAT"/></td>
            <td><xsl:value-of select="ZATRUDNIONY"/></td>
            <td><xsl:value-of select="PLACA_POD"/></td>
            <td>
                <xsl:choose>
                    <xsl:when test="ID_SZEFA != '' and key('pracownicyKey', ID_SZEFA)">
                        <xsl:value-of select="key('pracownicyKey', ID_SZEFA)/NAZWISKO"/>
                    </xsl:when>
                    <xsl:otherwise>brak</xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>