<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
    
    <xd:doc type="stylesheet">
        <xd:desc>
            <xd:p>Feuille de style de test qui transforme l'élément
				<xd:b>auteur</xd:b>.</xd:p>
        </xd:desc>
    </xd:doc>

    <xd:doc>
        <xd:desc>
            <xd:p>Peuple les méta-données pour les auteurs. On fait deux
				passes :</xd:p>
			<xd:ul>
				<xd:li>On remplace le premier espace entre le prénom et
					le nom par un élément <xd:b>&lt;separateur/&gt;</xd:b>.
				</xd:li>
				<xd:li>On découpe les blocs autour du séparateur.</xd:li>
            </xd:ul>
        </xd:desc> 
    </xd:doc>
    <xsl:template match="auteur">
        <AUTEUR>
            <AUTEUR-NOM-COMPLET>
                <xsl:variable name="prenom-nom-sep" >
                    <xsl:apply-templates select="aute" mode="prenom-nom-sep"/>
                </xsl:variable>
                <xsl:variable name="prenom-nom">
                    <xsl:apply-templates select="$prenom-nom-sep" mode="prenom-nom-cut"/>
                </xsl:variable>
                <AUT-PRENOM><xsl:value-of select="$prenom-nom/AUT-PRENOM"/></AUT-PRENOM>
                <AUT-NOM><xsl:value-of select="$prenom-nom/AUT-NOM"/></AUT-NOM>
            </AUTEUR-NOM-COMPLET>
        </AUTEUR>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Passe 1 : Insertion de <xd:i>&lt;separateur/&gt;</xd:i>
				entre le prénom et le nom.</xd:p>
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
            <xd:p>Passe 2 : Injecte nom et prénom séparés par un élément
				<xd:i>&lt;separateur/&gt;</xd:i> dans les éléments 
				adéquats.</xd:p>
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
            <xd:p>Transformation identité pour le mode <xd:b>prenom-nom</xd:b>.
			</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="@*|node()" mode="prenom-nom-cut prenom-nom-sep"
				  priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
