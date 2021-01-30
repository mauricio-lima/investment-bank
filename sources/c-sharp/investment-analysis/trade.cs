using System;
using System.Collections.Generic;
using System.Text;

namespace investment_analysis
{
	interface ITrade
	{
		double Value		{ get; }
		string ClientSector	{ get; }
	}


	class Trade : ITrade
	{
		public double  Value		{ get; }
		public string  ClientSector	{ get; }
		public TRules  Rules		{ get; }
			
		public string  Category		{ get; set; }

		private void Initialize()
		{
			//this._rules = new TRules();
		}

		public Trade(Object input)
		{
			Type type = input.GetType();
			this.Value        = (double)type.GetProperty("Value").GetValue(input, null);
			this.ClientSector = (String)type.GetProperty("ClientSector").GetValue(input, null);

			this.Initialize();
		}

		public Trade(double Value, String ClientSector)
		{
			this.Value        = Value;
			this.ClientSector = ClientSector;

			this.Initialize();
		}
	}

}
