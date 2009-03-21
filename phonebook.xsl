
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match='blackbook'>
        <html>
            <head>
                <link rel='stylesheet' type='text/css' href='style.css'/>
            </head>
            <body>
                <center>
                    <font size='10px'>
                        <a href='phonebook_p.xml'>Версия для печати</a>
                    </font>
                    <table class='main' cellspacing='0' cellpadding='0'>
                        <tbody>
                            <tr>
                                <th id='jobtitle'>Должность</th>
                                <th id='name'>ФИО</th>
                                <th id='intphone'>Внутр</th>
                                <th id='mobile'>Мобильный</th>
                                <th id='speed'>Быстр</th>
                                <th id='email'>Email</th>
                            </tr>
                            <tr>
                                <td colspan='6'>
                                    <xsl:apply-templates select='company'/>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </center>
            </body>
        </html>
    </xsl:template>


    <xsl:template match='company'>
        <table width='100%' height='100%' cellspacing='0' cellpadding='0'>
            <tr>
                <th id='companyname' colspan='6'>
                    <xsl:value-of select='@name'/>
                </th>
            </tr>
            <xsl:apply-templates select='dep'/>
        </table>
    </xsl:template>

    <xsl:template match='dep'>
        <xsl:if test="@name!='-'">
        <tr>
            <th id = 'depname' colspan='6'>
                <xsl:choose>
                    <xsl:when test="@name!='-'">
                        <xsl:value-of select='@name'/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text disable-output-escaping="yes">&#160;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </th>
        </tr>
        </xsl:if>
        <tr>
            <td id='depcontent' colspan='6'>
                <table width='100%' height='100%' cellspacing='0' cellpadding='0'>
                    <xsl:for-each select='fax'>
                        <tr>
                            <td id='faxname'>
                                <xsl:value-of select='name'/>
                            </td>
                            <td id='faxvalue' colspan='6'>
                                <xsl:value-of select='value'/>
                            </td>
                        </tr>
                    </xsl:for-each>
                    
                </table>
            </td>
        </tr>
        <tr>
            <td id='depcontent' colspan='6'>
                <table width='100%' height='100%' cellspacing='0' cellpadding='0'>
                    <xsl:apply-templates select='title'/>
                </table>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match='title'>
        <tr>
            <td id='titlename'>
                <xsl:choose>
                    <xsl:when test="@name!='-'">
                        <xsl:value-of select='@name'/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text disable-output-escaping="yes">&#160;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            <td>
                <table width='100%' height='100%' colspan='5' cellspacing='0' cellpadding='0'>
                    <xsl:apply-templates select='human'/>
                </table>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match='human'>
        <tr>
            <td id='hname'>
                <table cellspacing='0' cellpadding='0' border='0' width='100%'>
                    <tr>
                        <td id='hlastname'>
                            <xsl:value-of select='lastname'/>
                        </td>
                        <td id='hfirstname'>
                            <xsl:value-of select='firstname'/>
                        </td>
                    </tr>
                </table>
            </td>
            <td id='intphone'>
                <xsl:value-of select='intphone'/>
            </td>
            <td id='mobile'>
                <xsl:value-of select='mobile'/>
            </td>
            <td id='speed'>
                <xsl:value-of select='speed'/>
            </td>
            <td id='email'>
                <xsl:variable name='email'>
                    <xsl:value-of select='email'/>
                </xsl:variable>
                <xsl:variable name='semail'>
                    <xsl:value-of select='semail'/>
                </xsl:variable>
                <a href="mailto:{$email}">
                    <xsl:value-of select='$semail'/>
                </a>
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>
