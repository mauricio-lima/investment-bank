using System;
using System.Collections.Generic;
using System.Text;

namespace investment_analysis
{
	class InvestmentAnalysis
	{
		//private TRules _Rules;

		private List<String>  categoriesList;

		public  List<ITrade>  Portfolio	{ get; }

		public  TRules Rules			{ get; }

		public List<String> categories	
		{ 
			get 
			{
				this.categoriesList.Clear();
				foreach (var trade in this.Portfolio)
				{
					this.categoriesList.Add((trade as Trade).Category);
				}

				return this.categoriesList;
			} 
		}
	
		public void Add(Trade trade)
		{
			this.Portfolio.Add(trade);
			trade.Category = Rules.Evaluate(trade);
		}

		public InvestmentAnalysis()
		{
			this.Portfolio = new List<ITrade>();
			this.categoriesList = new List<String>();

			this.Rules = new TRules();
		}
	}
}
