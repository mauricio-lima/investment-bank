using System;
using System.Collections.Generic;


namespace investment_analysis
{
	class Program
	{
		class LowRiskRule : IRule
		{
			public String Execute(ITrade trade)
			{
				return "LOWRISK";
			}

			public Boolean IsMatch(ITrade trade)
			{
				return (trade.Value < 1_000_000) && (trade.ClientSector.ToLower() == "public");
			}
		}


		class MediumRiskRule : IRule
		{
			public String Execute(ITrade trade)
			{
				return "MEDIUMRISK";
			}

			public Boolean IsMatch(ITrade trade)
			{
				return (trade.Value > 1_000_000) && (trade.ClientSector.ToLower() == "public");
			}
		}


		class HighRiskRule : IRule
		{
			public String Execute(ITrade trade)
			{
				return "HIGHRISK";
			}

			public Boolean IsMatch(ITrade trade)
			{
				return (trade.Value > 1_000_000) && (trade.ClientSector.ToLower() == "private");
			}
		}


		static void Main(string[] args)
		{
			var portfolio = new [] {
				new { Value = 2000000d, ClientSector = "Private" },
				new { Value =  400000d, ClientSector = "Public"  },
				new { Value =  500000d, ClientSector = "Public"  },
				new { Value = 3000000d, ClientSector = "Public"  }
			};


			var analysis = new InvestmentAnalysis();

			analysis.Rules.Clear();
			analysis.Rules.Add(new LowRiskRule   ());
			analysis.Rules.Add(new MediumRiskRule());
			analysis.Rules.Add(new HighRiskRule  ());

			foreach (var trade in portfolio)
			{
				analysis.Add(new Trade(trade));
			}

			//analysis.Portfolio.Add(new Trade(new { Value = 2000000d, ClientSector = "Private" }));
			//analysis.Portfolio.Add(new Trade(new { Value = 400000d, ClientSector = "Public" }));
			//analysis.Portfolio.Add(new Trade(new { Value = 500000d, ClientSector = "Public" }));
			//analysis.Portfolio.Add(new Trade(new { Value = 3000000d, ClientSector = "Public" }));

			Console.WriteLine();
			Console.WriteLine("     Value        Sector     Category");
			Console.WriteLine();
			foreach (Trade trade in analysis.Portfolio)
			{
				Console.WriteLine("{0,15}   {1,-8}   {2}", trade.Value.ToString("#,##0.00"), trade.ClientSector, trade.Category);
			}
			Console.WriteLine();
			Console.WriteLine();

			List<String> tradeCategories = analysis.categories;
			tradeCategories.ForEach(delegate (String category)
			{
				Console.WriteLine(" - {0}", category);
			});
			Console.ReadKey();

		}
	}
}
