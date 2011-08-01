package es.gasonline.gsp.site.utils
{
	public class NumberUtils
	{		
		/**
		 * @method
		 * Genera un número aleatorio comprendido entre los valores 'low' y 'high', incluyendo ambos extremos
		 */
		public static function randomNumber(low:Number=NaN, high:Number=NaN):Number
		{
		  var low:Number = low;
		  var high:Number = high;
		
		  if(isNaN(low))
		  {
		    throw new Error("low must be defined");
		  }
		  if(isNaN(high))
		  {
		    throw new Error("high must be defined");
		  }
		
		  return Math.round(Math.random() * (high - low)) + low;
		}
	}
}