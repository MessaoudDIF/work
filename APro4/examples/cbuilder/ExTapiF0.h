// ***** BEGIN LICENSE BLOCK *****
// * Version: MPL 1.1
// *
// * The contents of this file are subject to the Mozilla Public License Version
// * 1.1 (the "License"); you may not use this file except in compliance with
// * the License. You may obtain a copy of the License at
// * http://www.mozilla.org/MPL/
// *
// * Software distributed under the License is distributed on an "AS IS" basis,
// * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
// * for the specific language governing rights and limitations under the
// * License.
// *
// * The Original Code is TurboPower Async Professional
// *
// * The Initial Developer of the Original Code is
// * TurboPower Software
// *
// * Portions created by the Initial Developer are Copyright (C) 1991-2002
// * the Initial Developer. All Rights Reserved.
// *
// * Contributor(s):
// *
// * ***** END LICENSE BLOCK *****

/*********************************************************/
/*                      EXTAPIF0.H                       */
/*********************************************************/
//---------------------------------------------------------------------------
#ifndef ExTapiF0H
#define ExTapiF0H
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include "AdPort.hpp"
#include "AdFax.hpp"
#include "AdFStat.hpp"
#include "AdTapi.hpp"
#include "OoMisc.hpp"
//---------------------------------------------------------------------------
class TExTFax : public TForm
{
__published:	// IDE-managed Components
	TApdComPort *ApdComPort1;
	TApdReceiveFax *ApdReceiveFax1;
	TApdSendFax *ApdSendFax1;
	TApdFaxStatus *ApdFaxStatus1;
	TApdFaxLog *ApdFaxLog1;
	TApdTapiDevice *ApdTapiDevice1;
	TButton *SendFax;
	TButton *RcvFax;
	void __fastcall SendFaxClick(TObject *Sender);
	void __fastcall RcvFaxClick(TObject *Sender);
	void __fastcall ApdReceiveFax1FaxFinish(TObject *CP, int ErrorCode);
	void __fastcall ApdSendFax1FaxFinish(TObject *CP, int ErrorCode);
	void __fastcall ApdTapiDevice1TapiPortOpen(TObject *Sender);
private:	// User declarations
	bool Sending;
public:		// User declarations
	virtual __fastcall TExTFax(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TExTFax *ExTFax;
//---------------------------------------------------------------------------
#endif