<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
                exclude-result-prefixes="xs els xd"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:els="http://lefebvre-sarrut.eu"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    
    <xd:doc type="stylesheet">
        <xd:desc>
            <xd:p>Gestion des matédonnées (dates, auteur, thèmes).</xd:p>
        </xd:desc>
    </xd:doc>

    <xd:doc>
        <xd:desc>
            <xd:p>Peuple les méta-données pour les auteurs.</xd:p>
        </xd:desc> 
    </xd:doc>
    <xsl:template match="auteur">
        <AUTEUR>
            <AUTEUR-NOM-COMPLET>
                <!-- on fait deux passes :
                1. On remplace le premier espace entre prénom et nom par un élément <separateur/>.
                2. On découpe les blocs autour du séparateur.
                -->
                <xsl:variable name="prenom-nom-sep" >
                    <xsl:apply-templates select="aute" mode="prenom-nom-sep"/>
                </xsl:variable>
                <xsl:variable name="prenom-nom">
                    <xsl:apply-templates select="$prenom-nom-sep" mode="prenom-nom-cut"/>
                </xsl:variable>
                <AUT-PRENOM><xsl:value-of select="$prenom-nom/AUT-PRENOM"/></AUT-PRENOM>
                <AUT-NOM><xsl:value-of select="$prenom-nom/AUT-NOM"/></AUT-NOM>
            </AUTEUR-NOM-COMPLET>
            <xsl:if test="affil">
                <AUTEUR-QUALITES>
                    <xsl:for-each select="affil">
                        <AUT-QUALITE><xsl:value-of select="."/></AUT-QUALITE>
                    </xsl:for-each>
                </AUTEUR-QUALITES>
            </xsl:if>
            <xsl:for-each select="aute/footnote">
                <AUTEUR-COMPL><xsl:value-of select="."/></AUTEUR-COMPL>
            </xsl:for-each>
        </AUTEUR>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Passe 1 : Insertion de <xd:i>&lt;separateur&gt;</xd:i> entre le prénom et le nom.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="text()" mode="prenom-nom-sep">
        <xsl:analyze-string select="." regex="\s+">
            <xsl:matching-substring>
                <separateur/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Passe 2 : Injecte nom et prénom séparés par un élément <xd:i>&lt;separateur&gt;</xd:i>
                dans les éléments adéquats.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="node()" mode="prenom-nom-cut">
        <xsl:for-each-group select="node()" group-ending-with="separateur">
            <xsl:variable name="content">
                <xsl:apply-templates select="current-group()"/>
            </xsl:variable>
            <xsl:variable name="content-as-string">
                <xsl:value-of select="$content"/>
            </xsl:variable>
            <xsl:if test="string-length($content-as-string) > 0">
                <xsl:choose>
                    <xsl:when test="position() = 1">
                        <AUT-PRENOM><xsl:sequence select="$content"/></AUT-PRENOM>
                    </xsl:when>
                    <xsl:otherwise>
                        <AUT-NOM><xsl:sequence select="$content"/></AUT-NOM>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each-group>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Neutralisation de l'élément separateur.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="separateur"/>

    <xd:doc>
        <xd:desc>
            <xd:p>Neutralisation de l'élément footnote.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="footnote"/>

    <xd:doc>
        <xd:desc>
            <xd:p>Tranformation identité pour les modes prenom-nom.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="@*|node()" mode="prenom-nom-cut prenom-nom-sep" priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Template identité appelé par les éléments devant être conservés tels-quels (ceux
                qui suivent).</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="identite">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
