using System;
using System.Collections.Generic;
using System.Text;


namespace investment_analysis
{
	interface IRule
	{
		String  Execute(ITrade trade);
		Boolean IsMatch(ITrade trade);
	}


	class TRules : List<IRule>
	{
		public String Evaluate(ITrade trade)
		{
			String result;

			result = "UNKNOWN";
			foreach (IRule rule in this)
			{
				if (rule.IsMatch(trade))
					result = rule.Execute(trade);
			}

			return result;
		}
	}
}

