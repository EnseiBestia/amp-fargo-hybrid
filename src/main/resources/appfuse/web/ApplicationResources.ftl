
# -- ${pojoAnno.annoFieldUtil.description}-START
<#assign pojoNameLower = pojo.shortName.substring(0,1).toLowerCase()+pojo.shortName.substring(1)>
<#foreach field in pojo.getAllPropertiesIterator()>
<#-- <#if !c2h.isCollection(field) && !c2h.isManyToOne(field) && !c2j.isComponent(field)> -->
<#if !c2h.isCollection(field) && !c2j.isComponent(field)>
    <#lt/>${pojoNameLower}.${field.name}=${pojoAnno.annoFieldUtil.getFieldDescription(field.name)}
</#if>
</#foreach>

${pojoNameLower}.added=${pojoAnno.annoFieldUtil.description}\u6dfb\u52a0\u6210\u529f\uff01
${pojoNameLower}.updated=${pojoAnno.annoFieldUtil.description}\u66f4\u65b0\u6210\u529f\uff01
${pojoNameLower}.deleted=${pojoAnno.annoFieldUtil.description}\u5220\u9664\u6210\u529f\uff01

# -- ${pojoNameLower} list page --
${pojoNameLower}List.title=${pojoAnno.annoFieldUtil.description}\u5217\u8868
${pojoNameLower}List.heading=${pojoAnno.annoFieldUtil.description}
${pojoNameLower}List.${pojoNameLower}=${pojoAnno.annoFieldUtil.description}
${pojoNameLower}List.${util.getPluralForWord(pojoNameLower)}=${pojoAnno.annoFieldUtil.description}
${pojoNameLower}List.message=\u4e0b\u9762\u662f${pojoAnno.annoFieldUtil.description}\u5217\u8868\uff0c\u4f60\u53ef\u4ee5\u6dfb\u52a0 \u3001\u67e5\u770b\u3001\u4fee\u6539\u6216\u5220\u9664${pojoAnno.annoFieldUtil.description}\u5bf9\u8c61\u3002


# -- ${pojoNameLower} detail page --
${pojoNameLower}Detail.title=${pojoAnno.annoFieldUtil.description}\u8be6\u60c5
${pojoNameLower}Detail.heading=${pojoAnno.annoFieldUtil.description}\u4fe1\u606f
${pojoNameLower}Detail.message=${pojoAnno.annoFieldUtil.description}\u8868\u5355\u4fe1\u606f
${pojoNameLower}Detail.add.message=\u8bf7\u8f93\u5165 ${pojoAnno.annoFieldUtil.description}\u4fe1\u606f
${pojoNameLower}Detail.view.message=\u4ee5\u4e0b\u662f ${pojoAnno.annoFieldUtil.description}\u4fe1\u606f
# -- ${pojoAnno.annoFieldUtil.description}-END