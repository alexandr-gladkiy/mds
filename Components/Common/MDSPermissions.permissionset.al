namespace MDS.Permissions;

using AG.MDS.Attributes;
using mds.mds;

permissionset 50100 "MDS Permissions"
{
    Assignable = true;
    Permissions = tabledata "MDS Attribute"=RIMD,
        tabledata "MDS Attribute Group"=RIMD,
        table "MDS Attribute"=X,
        table "MDS Attribute Group"=X,
        codeunit "MDS Attribute Group Service"=X,
        codeunit "MDS Attribute Management"=X,
        codeunit "MDS Attribute Service"=X,
        page "MDS Attribute Card"=X,
        page "MDS Attribute Group List"=X,
        page "MDS Attribute List"=X,
        page "MDS Role Center"=X,
        tabledata "MDS Data Provider"=RIMD,
        table "MDS Data Provider"=X,
        tabledata "MDS Source"=RIMD,
        table "MDS Source"=X,
        codeunit "MDS Data Provider Managment"=X,
        codeunit "MDS Data Provider Service"=X,
        page "MDS Data Provider List"=X;
}