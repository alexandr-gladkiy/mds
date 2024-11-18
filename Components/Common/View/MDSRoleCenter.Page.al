namespace mds.mds;
using System.Email;
using Microsoft.Finance.RoleCenters;

page 50103 "MDS Role Center"
{
    ApplicationArea = All;
    Caption = 'MDS Role Center';
    PageType = RoleCenter;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            part("User Tasks Activities"; "Email Activities") { }
            part("Acc. Payables Activities"; "Acc. Payables Activities") { }
        }
    }

    actions
    {
        area(Sections)
        {
            group(Setup)
            {
                Caption = 'Setup';
                action("MDS Setup")
                {
                    Caption = 'MDS Setup';
                    RunObject = page "MDS Setup Card";
                    RunPageMode = Edit;
                }
            }
            group("Attribute")
            {
                Caption = 'Attribute';

                action("Attribute Groups")
                {
                    Caption = 'Attribute Groups';
                    RunObject = page "MDS Attribute Group List";
                    RunPageMode = Edit;
                }

                action("Attribute List")
                {
                    Caption = 'Attribute List';
                    RunObject = page "MDS Attribute List";
                    RunPageMode = Edit;
                }
            }
            group(Sources)
            {
                Caption = 'Sources';
                action("Data Provider")
                {
                    Caption = 'Data Provider';
                    RunObject = page "MDS Data Provider List";
                    RunPageMode = Edit;
                }
                action("Source")
                {
                    Caption = 'Source';
                    RunObject = page "MDS Data Request Config List";
                    RunPageMode = Edit;
                }
            }
        }
    }
}
