unit Morph.Sample;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Morph, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, FireDAC.Phys.FB, FireDAC.Phys.FBDef;

type
  TSample = class(TForm)
    FDConnection1: TFDConnection;
    FDMemTable1: TFDMemTable;
    ComboBox1: TComboBox;
    Label1: TLabel;
    DBGrid1: TDBGrid;
    FDMTOrder: TFDMemTable;
    FDMTOrderID: TIntegerField;
    FDMTOrderCLIENT_ID: TIntegerField;
    FDMTOrderPRODUCT_ID: TIntegerField;
    FDMTOrderQUANTITY: TFloatField;
    FDMTOrderORDER_DATE: TDateField;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
      Morph : TMorph;
      procedure ExecutarAlteracoes;
  public
    { Public declarations }
  end;

var
  Sample: TSample;

implementation

uses
  Morph.EnumeratedTypes, Morph.MorphTable, Morph.Settings, System.JSON;

{$R *.dfm}

procedure TSample.ExecutarAlteracoes;
var
  MorphTableArrange : TMphTableArrange;
  Settings : TMorphSettings;
  InsertJSON : TJSONArray;
  ConfigString : String;
  ClientMorphTable : TMphTable;
  Conteudo : String;
  JSONLine : TJSONObject;
  JSONString : String;
begin
  {$REGION 'Tables creation'}

  Morph.Table('CLIENT')
          .Field('ID').tInteger.PrimaryKey.NotNull
          .Field('NAME').tVarchar(100).NotNull
          .Field('EMAIL').tVarchar(100).NotNull.Unique
          .Field('PHONE').tVarchar(15).NotNull.Unique
        .CreateTable;

   Morph.Table('SELLER')
          .Field('ID').tInteger.PrimaryKey.NotNull
          .Field('NAME').tVarchar(100).NotNull
          .Field('EMAIL').tVarchar(100).NotNull.Unique
          .Field('DEPARTMENT').tVarchar(30)
       .CreateTable;

  Morph.Table('PRODUCT')
          .Field('ID').tInteger.PrimaryKey.NotNull
          .Field('DESCRIPTION').tVarchar(100).NotNull
          .Field('CATEGORY').tVarchar(15).NotNull
          .Field('PRICE').tFloat.NotNull
        .CreateTable;

  Morph.Table('ORDER')
          .Field('ID').tInteger.PrimaryKey.NotNull
          .Field('CLIENT_ID').tInteger.ForeignKey.References.Table('CLIENT').Field('ID').NoOrphaData
          .Field('SELLER_ID').tInteger.ForeignKey.References.Table('SELLER').Field('ID').NoOrphaData
          .Field('PRODUCT_ID').tInteger.ForeignKey.References.Table('PRODUCT').Field('ID').NoOrphaData
          .Field('QUANTITY').tFloat.NotNull
          .Field('ORDER_DATE').tDate.NotNull
        .CreateTable;
  {$ENDREGION}

  {$REGION 'Fields population'}
  //Line Insert
  Morph.InsertInto.Table('CLIENT').Fields(['ID', 'NAME',         'EMAIL',          'PHONE'])
                                  .Values(['1',  'John Smith',   'John@email.com', '9999-1111'])
                                  .Values(['1',  'Mary Johnson', 'mary@email.com', '9999-2222'])
                  .Post;

  Morph.InsertInto.Table('CLIENT').Fields(['ID',   'NAME',   'EMAIL',  'PHONE'])
                                  .Values(['5000', 'TEST',   'DELETE', '0000-0000'])
                  .Post;
  //MorphTable Insert
  ClientMorphTable := TMphTable.Create;
  try
    {$REGION 'Preparing Morph Table'}
    ClientMorphTable.Clear;
    ClientMorphTable.Name := 'CLIENT'; //Optional

    ClientMorphTable.AddField('ID').TypeInteger
                    .AddField('NAME').TypeString
                    .AddField('EMAIL').TypeString
                    .AddField('PHONE').TypeString;

    ClientMorphTable.NewLine
                        .SetFields(0).AsInteger(3)
                        .SetFields(1).AsString('Charles Brown')
                        .SetFields(2).AsString('charles@email.com')
                        .SetFields(3).AsString('9999-3333')
                    .NewLine
                        .SetFieldByname('ID').AsInteger(4)
                        .SetFieldByname('NAME').AsString('Anna Davis')
                        .SetFieldByname('EMAIL').AsString('anna@email.com')
                        .SetFieldByname('PHONE').AsString('9999-4444')
                    .NewLine
                        .SetFieldByName('ID').AsInteger(5)
                        .SetFieldByName('NAME').AsString('Peter Wilson')
                        .SetFieldByName('EMAIL').AsString('peter@email.com')
                        .SetFieldByName('PHONE').AsString('9999-5555')
                    .NewLine
                        .SetFieldByName('ID').AsInteger(6)
                        .SetFieldByName('NAME').AsString('Laura Miller')
                        .SetFieldByName('EMAIL').AsString('laura@email.com')
                        .SetFieldByName('PHONE').AsString('9999-6666')
                    .NewLine
                        .SetFieldByName('ID').AsInteger(7)
                        .SetFieldByName('NAME').AsString('Brian White')
                        .SetFieldByName('EMAIL').AsString('brian@email.com')
                        .SetFieldByName('PHONE').AsString('9999-7777')
                    .NewLine
                        .SetFieldByName('ID').AsInteger(8)
                        .SetFieldByName('NAME').AsString('Paula Harris')
                        .SetFieldByName('EMAIL').AsString('paula@email.com')
                        .SetFieldByName('PHONE').AsString('9999-8888')
                    .NewLine
                        .SetFieldByName('ID').AsInteger(9)
                        .SetFieldByName('NAME').AsString('Andrew Clark')
                        .SetFieldByName('EMAIL').AsString('andrew@email.com')
                        .SetFieldByName('PHONE').AsString('9999-9999')
                    .NewLine
                        .SetFieldByName('ID').AsInteger(10)
                        .SetFieldByName('NAME').AsString('Sophia Lewis')
                        .SetFieldByName('EMAIL').AsString('sophia@email.com')
                        .SetFieldByName('PHONE').AsString('9999-0000')
                    .NewLine
                        .SetFieldByName('ID').AsInteger(11)
                        .SetFieldByName('NAME').AsString('Thomas Young')
                        .SetFieldByName('EMAIL').AsString('thomas@email.com')
                        .SetFieldByName('PHONE').AsString('9999-1234')
                    .NewLine
                        .SetFieldByName('ID').AsInteger(12)
                        .SetFieldByName('NAME').AsString('Vanessa Hall')
                        .SetFieldByName('EMAIL').AsString('vanessa@email.com')
                        .SetFieldByName('PHONE').AsString('9999-2345')
                    .NewLine
                        .SetFieldByName('ID').AsInteger(13)
                        .SetFieldByName('NAME').AsString('Lucas Allen')
                        .SetFieldByName('EMAIL').AsString('lucas@email.com')
                        .SetFieldByName('PHONE').AsString('9999-3456')
                    .NewLine
                        .SetFieldByName('ID').AsInteger(14)
                        .SetFieldByName('NAME').AsString('Daniel Scott')
                        .SetFieldByName('EMAIL').AsString('daniel@email.com')
                        .SetFieldByName('PHONE').AsString('9999-4567')
                    .NewLine
                        .SetFieldByName('ID').AsInteger(15)
                        .SetFieldByName('NAME').AsString('Rachel King')
                        .SetFieldByName('EMAIL').AsString('rachel@email.com')
                        .SetFieldByName('PHONE').AsString('9999-5678')
                    .Post;
    {$ENDREGION}
    Morph.InsertInto.Table('CLIENT').Content(ClientMorphTable);
  finally
    ClientMorphTable.Free;
  end;

  //JSON Fields Insert with TJSONObject
  InsertJSON := TJSONArray.Create;
  try
    {$REGION 'Preparing JSON'}
    JSONLine := TJSONObject.Create;
    JSONLine.AddPair('ID', 1);
    JSONLine.AddPair('NAME', 'Fernanda Cruz');
    JSONLine.AddPair('EMAIL', 'fernanda@sales.com');
    JSONLine.AddPair('DEPARTMENT', 'Electronics');
    InsertJSON.Add(JSONLine);

    JSONLine := TJSONObject.Create;
    JSONLine.AddPair('ID', 2);
    JSONLine.AddPair('NAME', 'Mark Green');
    JSONLine.AddPair('EMAIL', 'mark@sales.com');
    JSONLine.AddPair('DEPARTMENT', 'Clothing');
    InsertJSON.Add(JSONLine);

    JSONLine := TJSONObject.Create;
    JSONLine.AddPair('ID', 3);
    JSONLine.AddPair('NAME', 'Julia Brown');
    JSONLine.AddPair('EMAIL', 'julia@sales.com');
    JSONLine.AddPair('DEPARTMENT', 'Food');
    InsertJSON.Add(JSONLine);

    JSONLine := TJSONObject.Create;
    JSONLine.AddPair('ID', 4);
    JSONLine.AddPair('NAME', 'Diego Torres');
    JSONLine.AddPair('EMAIL', 'diego@sales.com');
    JSONLine.AddPair('DEPARTMENT', 'IT');
    InsertJSON.Add(JSONLine);

    JSONLine := TJSONObject.Create;
    JSONLine.AddPair('ID', 5);
    JSONLine.AddPair('NAME', 'Camila White');
    JSONLine.AddPair('EMAIL', 'camila@sales.com');
    JSONLine.AddPair('DEPARTMENT', 'Furniture');
    InsertJSON.Add(JSONLine);

    JSONLine := TJSONObject.Create;
    JSONLine.AddPair('ID', 6);
    JSONLine.AddPair('NAME', 'Edward Miller');
    JSONLine.AddPair('EMAIL', 'edward@sales.com');
    JSONLine.AddPair('DEPARTMENT', 'Beauty');
    InsertJSON.Add(JSONLine);

    JSONLine := TJSONObject.Create;
    JSONLine.AddPair('ID', 7);
    JSONLine.AddPair('NAME', 'Carla Moore');
    JSONLine.AddPair('EMAIL', 'carla@sales.com');
    JSONLine.AddPair('DEPARTMENT', 'Sports');
    InsertJSON.Add(JSONLine);

    JSONLine := TJSONObject.Create;
    JSONLine.AddPair('ID', 8);
    JSONLine.AddPair('NAME', 'Gabriel Adams');
    JSONLine.AddPair('EMAIL', 'gabriel@sales.com');
    JSONLine.AddPair('DEPARTMENT', 'Automotive');
    InsertJSON.Add(JSONLine);

    JSONLine := TJSONObject.Create;
    JSONLine.AddPair('ID', 9);
    JSONLine.AddPair('NAME', 'Maria Walker');
    JSONLine.AddPair('EMAIL', 'maria@sales.com');
    JSONLine.AddPair('DEPARTMENT', 'Stationery');
    InsertJSON.Add(JSONLine);

    JSONLine := TJSONObject.Create;
    JSONLine.AddPair('ID', 10);
    JSONLine.AddPair('NAME', 'Alex Hill');
    JSONLine.AddPair('EMAIL', 'alex@sales.com');
    JSONLine.AddPair('DEPARTMENT', 'Accessories');
    InsertJSON.Add(JSONLine);

    JSONLine := TJSONObject.Create;
    JSONLine.AddPair('ID', 11);
    JSONLine.AddPair('NAME', 'Paula Martin');
    JSONLine.AddPair('EMAIL', 'paula@sales.com');
    JSONLine.AddPair('DEPARTMENT', 'Home');
    InsertJSON.Add(JSONLine);

    JSONLine := TJSONObject.Create;
    JSONLine.AddPair('ID', 12);
    JSONLine.AddPair('NAME', 'Robert Evans');
    JSONLine.AddPair('EMAIL', 'robert@sales.com');
    JSONLine.AddPair('DEPARTMENT', 'Tools');
    InsertJSON.Add(JSONLine);

    JSONLine := TJSONObject.Create;
    JSONLine.AddPair('ID', 13);
    JSONLine.AddPair('NAME', 'Amanda Baker');
    JSONLine.AddPair('EMAIL', 'amanda@sales.com');
    JSONLine.AddPair('DEPARTMENT', 'Beverages');
    InsertJSON.Add(JSONLine);

    JSONLine := TJSONObject.Create;
    JSONLine.AddPair('ID', 14);
    JSONLine.AddPair('NAME', 'Philip Perez');
    JSONLine.AddPair('EMAIL', 'philip@sales.com');
    JSONLine.AddPair('DEPARTMENT', 'Books');
    InsertJSON.Add(JSONLine);

    JSONLine := TJSONObject.Create;
    JSONLine.AddPair('ID', 15);
    JSONLine.AddPair('NAME', 'Bianca Carter');
    JSONLine.AddPair('EMAIL', 'bianca@sales.com');
    JSONLine.AddPair('DEPARTMENT', 'Music');
    InsertJSON.Add(JSONLine);
    {$ENDREGION}

    Morph.InsertInto.Table('SELLER').Content(TMorph.JSONParse(InsertJSON.ToJSON));
  finally
    InsertJSON.Free;
    JSONLine.Free;
  end;

  //JSON Fields Insert with JSON pure string
  {$REGION 'Building JSON'}
  JSONString := '[                                              '+
                  '   {                                         '+
                  '       "ID":1,                               '+
                  '       "DESCRIPTION":"Laptop",               '+
                  '       "CATEGORY":"IT",                      '+
                  '       "PRICE":4500.00                       '+
                  '   },                                        '+
                  '   {                                         '+
                  '       "ID":2,                               '+
                  '       "DESCRIPTION":"Smartphone",           '+
                  '       "CATEGORY":"Electronics",             '+
                  '       "PRICE":3000.00                       '+
                  '   },                                        '+
                  '   {                                         '+
                  '       "ID":3,                               '+
                  '       "DESCRIPTION":"T-Shirt",              '+
                  '       "CATEGORY":"Clothing",                '+
                  '       "PRICE":80.00                         '+
                  '   },                                        '+
                  '   {                                         '+
                  '       "ID":4,                               '+
                  '       "DESCRIPTION":"Refrigerator",         '+
                  '       "CATEGORY":"Appliances",              '+
                  '       "PRICE":3200.00                       '+
                  '   },                                        '+
                  '   {                                         '+
                  '       "ID":5,                               '+
                  '       "DESCRIPTION":"Gaming Chair",         '+
                  '       "CATEGORY":"Furniture",               '+
                  '       "PRICE":900.00                        '+
                  '   },                                        '+
                  '   {                                         '+
                  '       "ID":6,                               '+
                  '       "DESCRIPTION":"Running Shoes",        '+
                  '       "CATEGORY":"Sports",                  '+
                  '       "PRICE":350.00                        '+
                  '   },                                        '+
                  '   {                                         '+
                  '       "ID":7,                               '+
                  '       "DESCRIPTION":"Bluetooth Headphones", '+
                  '       "CATEGORY":"Accessories",             '+
                  '       "PRICE":250.00                        '+
                  '   },                                        '+
                  '   {                                         '+
                  '       "ID":8,                               '+
                  '       "DESCRIPTION":"Technical Book",       '+
                  '       "CATEGORY":"Books",                   '+
                  '       "PRICE":120.00                        '+
                  '   },                                        '+
                  '   {                                         '+
                  '       "ID":9,                               '+
                  '       "DESCRIPTION":"Smart Watch",          '+
                  '       "CATEGORY":"Electronics",             '+
                  '       "PRICE":600.00                        '+
                  '   },                                        '+
                  '   {                                         '+
                  '       "ID":10,                              '+
                  '       "DESCRIPTION":"Bicycle",              '+
                  '       "CATEGORY":"Sports",                  '+
                  '       "PRICE":2200.00                       '+
                  '   },                                        '+
                  '   {                                         '+
                  '       "ID":11,                              '+
                  '       "DESCRIPTION":"Mechanical Keyboard",  '+
                  '       "CATEGORY":"IT",                      '+
                  '       "PRICE":400.00                        '+
                  '   },                                        '+
                  '   {                                         '+
                  '       "ID":12,                              '+
                  '       "DESCRIPTION":"Imported Perfume",     '+
                  '       "CATEGORY":"Beauty",                  '+
                  '       "PRICE":700.00                        '+
                  '   },                                        '+
                  '   {                                         '+
                  '       "ID":13,                              '+
                  '       "DESCRIPTION":"School Backpack",      '+
                  '       "CATEGORY":"Stationery",              '+
                  '       "PRICE":150.00                        '+
                  '   },                                        '+
                  '   {                                         '+
                  '       "ID":14,                              '+
                  '       "DESCRIPTION":"3-Seat Sofa",          '+
                  '       "CATEGORY":"Furniture",               '+
                  '       "PRICE":2500.00                       '+
                  '   },                                        '+
                  '   {                                         '+
                  '       "ID":15,                              '+
                  '       "DESCRIPTION":"12-Year Whisky",       '+
                  '       "CATEGORY":"Beverages",               '+
                  '       "PRICE":350.00                        '+
                  '   }                                         '+
                  ']                                            ';
  {$ENDREGION}

  Morph.InsertInto.Table('PRODUCT').Content(TMorph.JSONParse(JSONString));

  //TFDMemTable Table Insert
  {$REGION 'Populating TFDMemTable'}
  FDMTOrder.Open;

  FDMTOrder.Append;
  FDMTOrderID.AsInteger := 1;
  FDMTOrderCLIENT_ID.AsInteger := 1;
  FDMTOrderPRODUCT_ID.AsInteger := 2;
  FDMTOrderQUANTITY.AsFloat := 1;
  FDMTOrderORDER_DATE.AsDateTime :=  EncodeDate(2025, 2, 1);
  FDMTOrder.Post;

  FDMTOrder.Append;
  FDMTOrderID.AsInteger := 2;
  FDMTOrderCLIENT_ID.AsInteger := 3;
  FDMTOrderPRODUCT_ID.AsInteger := 5;
  FDMTOrderQUANTITY.AsFloat := 2;
  FDMTOrderORDER_DATE.AsDateTime := EncodeDate(2025, 2, 2);
  FDMTOrder.Post;

  FDMTOrder.Append;
  FDMTOrderID.AsInteger := 3;
  FDMTOrderCLIENT_ID.AsInteger := 5;
  FDMTOrderPRODUCT_ID.AsInteger := 8;
  FDMTOrderQUANTITY.AsFloat := 1;
  FDMTOrderORDER_DATE.AsDateTime := EncodeDate(2025, 2, 3);
  FDMTOrder.Post;

  FDMTOrder.Append;
  FDMTOrderID.AsInteger := 4;
  FDMTOrderCLIENT_ID.AsInteger := 2;
  FDMTOrderPRODUCT_ID.AsInteger := 10;
  FDMTOrderQUANTITY.AsFloat := 1;
  FDMTOrderORDER_DATE.AsDateTime := EncodeDate(2025, 2, 4);
  FDMTOrder.Post;

  FDMTOrder.Append;
  FDMTOrderID.AsInteger := 5;
  FDMTOrderCLIENT_ID.AsInteger := 6;
  FDMTOrderPRODUCT_ID.AsInteger := 15;
  FDMTOrderQUANTITY.AsFloat := 3;
  FDMTOrderORDER_DATE.AsDateTime := EncodeDate(2025, 2, 5);
  FDMTOrder.Post;

  FDMTOrder.Append;
  FDMTOrderID.AsInteger := 6;
  FDMTOrderCLIENT_ID.AsInteger := 8;
  FDMTOrderPRODUCT_ID.AsInteger := 7;
  FDMTOrderQUANTITY.AsFloat := 1;
  FDMTOrderORDER_DATE.AsDateTime := EncodeDate(2025, 2, 6);
  FDMTOrder.Post;

  FDMTOrder.Append;
  FDMTOrderID.AsInteger := 7;
  FDMTOrderCLIENT_ID.AsInteger := 10;
  FDMTOrderPRODUCT_ID.AsInteger := 12;
  FDMTOrderQUANTITY.AsFloat := 1;
  FDMTOrderORDER_DATE.AsDateTime := EncodeDate(2025, 2, 7);
  FDMTOrder.Post;

  FDMTOrder.Append;
  FDMTOrderID.AsInteger := 8;
  FDMTOrderCLIENT_ID.AsInteger := 4;
  FDMTOrderPRODUCT_ID.AsInteger := 3;
  FDMTOrderQUANTITY.AsFloat := 5;
  FDMTOrderORDER_DATE.AsDateTime := EncodeDate(2025, 2, 8);
  FDMTOrder.Post;

  FDMTOrder.Append;
  FDMTOrderID.AsInteger := 9;
  FDMTOrderCLIENT_ID.AsInteger := 9;
  FDMTOrderPRODUCT_ID.AsInteger := 6;
  FDMTOrderQUANTITY.AsFloat := 2;
  FDMTOrderORDER_DATE.AsDateTime := EncodeDate(2025, 2, 9);
  FDMTOrder.Post;

  FDMTOrder.Append;
  FDMTOrderID.AsInteger := 10;
  FDMTOrderCLIENT_ID.AsInteger := 7;
  FDMTOrderPRODUCT_ID.AsInteger := 1;
  FDMTOrderQUANTITY.AsFloat := 1;
  FDMTOrderORDER_DATE.AsDateTime := EncodeDate(2025, 2, 10);
  FDMTOrder.Post;

  FDMTOrder.Append;
  FDMTOrderID.AsInteger := 11;
  FDMTOrderCLIENT_ID.AsInteger := 12;
  FDMTOrderPRODUCT_ID.AsInteger := 14;
  FDMTOrderQUANTITY.AsFloat := 1;
  FDMTOrderORDER_DATE.AsDateTime := EncodeDate(2025, 2, 11);
  FDMTOrder.Post;

  FDMTOrder.Append;
  FDMTOrderID.AsInteger := 12;
  FDMTOrderCLIENT_ID.AsInteger := 15;
  FDMTOrderPRODUCT_ID.AsInteger := 4;
  FDMTOrderQUANTITY.AsFloat := 1;
  FDMTOrderORDER_DATE.AsDateTime := EncodeDate(2025, 2, 12);
  FDMTOrder.Post;

  FDMTOrder.Append;
  FDMTOrderID.AsInteger := 13;
  FDMTOrderCLIENT_ID.AsInteger := 13;
  FDMTOrderPRODUCT_ID.AsInteger := 11;
  FDMTOrderQUANTITY.AsFloat := 2;
  FDMTOrderORDER_DATE.AsDateTime := EncodeDate(2025, 2, 13);
  FDMTOrder.Post;

  FDMTOrder.Append;
  FDMTOrderID.AsInteger := 14;
  FDMTOrderCLIENT_ID.AsInteger := 11;
  FDMTOrderPRODUCT_ID.AsInteger := 9;
  FDMTOrderQUANTITY.AsFloat := 1;
  FDMTOrderORDER_DATE.AsDateTime := EncodeDate(2025, 2, 14);
  FDMTOrder.Post;

  FDMTOrder.Append;
  FDMTOrderID.AsInteger := 15;
  FDMTOrderCLIENT_ID.AsInteger := 14;
  FDMTOrderPRODUCT_ID.AsInteger := 13;
  FDMTOrderQUANTITY.AsFloat := 3;
  FDMTOrderORDER_DATE.AsDateTime := EncodeDate(2025, 2, 15);
  FDMTOrder.Post;
  {$ENDREGION}

  Morph.InserFDMEMtableInto('ORDER').FDMemTable(FDMemTable1);
  {$ENDREGION}

  {$REGION 'Dropping entire columns'}
  Morph.Table('SELLER').Field('EMAIL').Drop;
  Morph.Table('ORDER').Field('ORDER_DATE').Drop;
  {$ENDREGION}

  {$REGION 'Add fields on existing tables'}
  Morph.Table('CLIENT').Field('LAST_VISIT').tDate
                       .Field('CREDIT').tFloat

       .Table('SELLER').Field('COMISSION').tFloat
                       .Field('OBS').tVarchar(50)
       .Add;

  Morph.Table('SELLER').Field('ACTIVE').tBoolean.NotNull.Add;
  {$ENDREGION}

  {$REGION 'Update'}

  {$REGION 'Equals'}
   Morph.Update.Table('CLIENT')

       .SetField('LAST_VISIT').NewValue<TDateTime>(EncodeDate(2025, 2, 1))
       .SetField('CREDIT').NewValue<Extended>(1200.50)
       .Where.Field('ID').Equals<Integer>(1)

       .SetField('LAST_VISIT').NewValue<TDateTime>(EncodeDate(2025, 2, 5))
       .SetField('CREDIT').NewValue<Extended>(850.75)
       .Where.Field('ID').Equals<Integer>(2)

       .SetField('LAST_VISIT').NewValue<TDateTime>(EncodeDate(2025, 1, 20))
       .SetField('CREDIT').NewValue<Extended>(500.00)
       .Where.Field('ID').Equals<Integer>(3)

       .SetField('LAST_VISIT').NewValue<TDateTime>(EncodeDate(2025, 2, 7))
       .SetField('CREDIT').NewValue<Extended>(1300.30)
       .Where.Field('ID').Equals<Integer>(4)

       .SetField('LAST_VISIT').NewValue<TDateTime>(EncodeDate(2025, 2, 10))
       .SetField('CREDIT').NewValue<Extended>(900.00)
       .Where.Field('ID').Equals<Integer>(5)

       .SetField('LAST_VISIT').NewValue<TDateTime>(EncodeDate(2025, 1, 15))
       .SetField('CREDIT').NewValue<Extended>(700.60)
       .Where.Field('ID').Equals<Integer>(6)

       .SetField('LAST_VISIT').NewValue<TDateTime>(EncodeDate(2025, 2, 3))
       .SetField('CREDIT').NewValue<Extended>(600.90)
       .Where.Field('ID').Equals<Integer>(7)

       .SetField('LAST_VISIT').NewValue<TDateTime>(EncodeDate(2025, 2, 4))
       .SetField('CREDIT').NewValue<Extended>(1100.25)
       .Where.Field('ID').Equals<Integer>(8)

       .SetField('LAST_VISIT').NewValue<TDateTime>(EncodeDate(2025, 1, 29))
       .SetField('CREDIT').NewValue<Extended>(450.00)
       .Where.Field('ID').Equals<Integer>(9)

       .SetField('LAST_VISIT').NewValue<TDateTime>(EncodeDate(2025, 2, 9))
       .SetField('CREDIT').NewValue<Extended>(950.40)
       .Where.Field('ID').Equals<Integer>(10)

       .SetField('LAST_VISIT').NewValue<TDateTime>(EncodeDate(2025, 1, 31))
       .SetField('CREDIT').NewValue<Extended>(500.00)
       .Where.Field('ID').Equals<Integer>(11)

       .SetField('LAST_VISIT').NewValue<TDateTime>(EncodeDate(2025, 2, 6))
       .SetField('CREDIT').NewValue<Extended>(750.80)
       .Where.Field('ID').Equals<Integer>(12)

       .SetField('LAST_VISIT').NewValue<TDateTime>(EncodeDate(2025, 2, 2))
       .SetField('CREDIT').NewValue<Extended>(880.10)
       .Where.Field('ID').Equals<Integer>(13)

       .SetField('LAST_VISIT').NewValue<TDateTime>(EncodeDate(2025, 2, 1))
       .SetField('CREDIT').NewValue<Extended>(620.50)
       .Where.Field('ID').Equals<Integer>(14)

       .SetField('LAST_VISIT').NewValue<TDateTime>(EncodeDate(2025, 2, 7))
       .SetField('CREDIT').NewValue<Extended>(1025.00)
       .Where.Field('ID').Equals<Integer>(15);
  {$ENDREGION}

  {$REGION 'BigerThan / SmallerThan'}
  Morph.Update.Table('CLIENT').SetField('CREDIT').NewValue<Extended>(200)
       .Where.Field('CREDIT').IsBiggerThan<Integer>(500)
         ._And.Field('LAST_VISIT').IsSmallerThen<TDateTime>(EncodeDate(2025, 1, 1));

  Morph.Update.Table('SELLER').SetField('ACTIVE').NewValue<Boolean>(False)
       .Where.Field('DEPARTMENT').Equals<String>('Clothing');

  Morph.Update.Table('SELLER').SetField('OBS').NewValue<TMorphEmptyType>(Empty)
  .Where.Field('ACTIVE').Equals<Boolean>(False);
  {$ENDREGION}

  {$REGION 'Delete Line'}
  Morph.Delete.Table('CLIENT').Where.Field('NAME').Equals<String>('TEST');
  {$ENDREGION}

  {$REGION 'Select'}
  Morph.Select.All.From('ORDER').Where.Field('CLIENT_ID').IsBiggerOrEqualThen<Integer>(5)
                                  ._Or.Field('CLIENT').IsSmallerOrEqualThen<Integer>(9);
  {$ENDREGION}

  {$ENDREGION}
//=======================================================================================================
  {
  //Configuration
  Settings.LoadFromJSONString(ConfigString);
  Settings.ExportToJSONString;

  Morph.Config.DatabaseType(FB5)
              .Connection(FDConnection1)
              .OutputFDMemTable(FDMemTable1)
              .OutputMorphTable(ClientMorphTable)
              .IgnoreCreatedStructure
              .DoNotRaiseOnRedundances
              .RunFindInAnOtherThread
              .LoadSettings(Settings)
              .ExportSettings;

  //Delete table
  Morph.Table('PEOPLE')
       .Table('CITY')
       .Table('PRODUCT')
       .Drop.CurrentSQLCommand;

  //Remove all data from table
  Morph.Table('PEOPLE')
       .Table('CITY')
       .Table('PRODUCT')
       .Delete;

  //Change table name
  Morph.Table('PEOPLE').ChangeNameTo('PEOPLE_DATA')
          .Table('CITY').ChangeNameTo('CITY_INFO')
       .Table('PRODUCT').ChangeNameTo('PRODUCT_DATA');

  //Create Table
  Morph.Table('PEOPLE').Field('ID').Integer.PrimaryKey.Identity
                       .Field('NAME').Varchar(20).NotNull
                       .Field('ACTIVE').Boolean.NotNull
                       .Field('ACCESS_KEY').Varchar(10).Unique
                       .Field('CREDIT').Float
                       .Field('REGISTER_DATE').Date
                       .Field('PICTURE').BynaryBlob

        .Table('CITY').Field('ID').Integer.PrimaryKey
                      .Field('NAME').Varchar(15).NotNull

        .Table('PRODUCT').Field('ID').Integer.PrimaryKey
                         .Field('NAME').Varchar(30).NotNull
                         .Field('PRICE').Float
        .Create;

  //Add Fields in Table
  Morph.Table('PEOPLE').Field('LAST_VISIT').Date
       .Table('CITY').Field('POSTAL_CODE').Integer
       .Table('PRODUCT').Field('REGISTER_DATE').Date
                        .Field('QTD').Float.NotNull
       .Add;

  //Remove field from table:
  Morph.Table('PEOPLE').Field('ACCESS_KEY')
                       .Field('PICTURE')

       .Table('CITY').Field('POSTAL_CODE')
       .Drop;

  //Edit field name
  Morph.Table('PEOPLE').Field('ID').ChangeNameTo('CODE')
                       .Field('NAME').ChangeNameTo('CLI_NAME')
        .Table('CITY').Field('ID').ChangeNameTo('CODE')
        .Table('PRODUCT').Field('ID').ChangeNameTo('CODE');

  //Table Fields Info
  Morph.Table('PEOPLE').FieldsInfo;

  //Field Info
  Morph.Table('CITY').Field('CODIGO').FieldInfo;

  //Muktiple Insert
  Morph.InsertInto.Table('PEOPLE').Fields(['NAME', 'ACTIVE']).Values(['Fernando', 'False']);

  //JSON Tables and Fields Insert
  Morph.InsertJSON(InsertJSON.ToJSON);

  //JSON Fields Insert
  Morph.InsertJSONStringInto.Table('PEOPLE').JSONContent(InsertJSON.ToJSON);

  //TFDMemTable Table Insert
  Morph.InserFDMEMtableInto('PEOPLE').FDMemTable(FDMemTable1);

  //MorphTableArrange Config
  MorphTableArrange.ImportSettings(Settings);
  MorphTableArrange.ExportSettings;

  //Add tables to arrange: PAREI AQUI

  //MorphTable Config
  ClientMorphTable.ImportSettings(Settings);

  //Morph table insert
  ClientMorphTable.InsertInto('PEOPLE');

  //ExportData
  ClientMorphTable.AsFDMemtable;
  ClientMorphTable.AsJSONString;

  //ImportData
  ClientMorphTable.LoadFromFDMemtable(FDMemtable1);
  ClientMorphTable.LoadFromJSONString(Conteudo);

  //Update
  Morph.Update.Table('PEOPLE').SetField('NAME').NewValue('Marcos').Where;
  Morph.Update.Table('PEOPLE').SetFields(['NAME', 'ACTIVE']).NewValues(['Marcos', 'False']).Where;
  }
end;

procedure TSample.FormCreate(Sender: TObject);
begin
   Morph := TMorph.Create;

   Morph.Config.DatabaseType(FB5).Connection(FDConnection1);

   ExecutarAlteracoes;
end;

procedure TSample.FormDestroy(Sender: TObject);
begin
  Morph.Free;
end;


end.

