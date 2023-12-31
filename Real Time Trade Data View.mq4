//+------------------------------------------------------------------+
//|                                    Real Time Trade Data View.mq4 |
//|                                                           Andrii |
//+------------------------------------------------------------------+

#property indicator_chart_window
extern color TextColor        = clrYellow;
extern color BaseColor         = clrWhite;

int    k, d, per, day;
string sper, ssprd, instr;
string font = "Microsoft Sans Serif";

enum ENUM_RANGE{
   TO_YEAR,
   TO_MONTH, 
   TO_DAY, 
};

input ENUM_RANGE DATERANGE = 0;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   //ChartSetInteger(0, CHART_COLOR_BACKGROUND, clrRoyalBlue);
   //ChartSetInteger(0, CHART_COLOR_FOREGROUND, clrBlack);
   ChartSetInteger(0, CHART_SHOW_GRID, false);
   
   ChartSetInteger(0, CHART_SHOW_ASK_LINE, true);
   ChartSetInteger(0, CHART_COLOR_ASK, clrYellow);
   ChartSetInteger(0, CHART_SHOW_BID_LINE, true);
   ChartSetInteger(0, CHART_COLOR_BID, clrYellow);

   if (TimeDayOfWeek(Time[0]) == 1) day = 2; else day = 1;
   instr = Symbol();
   instr = StringSubstr(instr,0,6);
   per = Period();
   
   if (per < 60)
      sper = "M" + per;
   else if (per >= 60 && per < 60*24) 
      sper="H" + per/60 + " ";
   else
      sper="D" + per/(60*24);
   
   // Ask Price 
   ObjectCreate("L_AskPrice", OBJ_LABEL, 0, 0, 0);
   ObjectSet("L_AskPrice", OBJPROP_CORNER, 1);
   ObjectSet("L_AskPrice", OBJPROP_XDISTANCE, 120);
   ObjectSet("L_AskPrice", OBJPROP_YDISTANCE, 15);
   ObjectSetText("L_AskPrice", "ASK  ", 12, font, TextColor);
  
   ObjectCreate("Ask Price", OBJ_LABEL, 0, 0, 0);
   ObjectSet("Ask Price", OBJPROP_CORNER, 1);
   ObjectSet("Ask Price", OBJPROP_XDISTANCE, 15);
   ObjectSet("Ask Price", OBJPROP_YDISTANCE, 10);
  
   // Bid Price
   ObjectCreate("L_BidPrice", OBJ_LABEL,0, 0, 0);
   ObjectSet("L_BidPrice", OBJPROP_CORNER, 1);
   ObjectSet("L_BidPrice", OBJPROP_XDISTANCE, 120);
   ObjectSet("L_BidPrice", OBJPROP_YDISTANCE, 40);
   ObjectSetText("L_BidPrice", "BID  ", 12, font, TextColor);

   ObjectCreate("Bid Price", OBJ_LABEL, 0, 0, 0);
   ObjectSet("Bid Price", OBJPROP_CORNER, 1);
   ObjectSet("Bid Price", OBJPROP_XDISTANCE, 15);
   ObjectSet("Bid Price", OBJPROP_YDISTANCE, 35);
   
   // +----------------------------------
   ObjectCreate("L_Bar1", OBJ_LABEL, 0, 0, 0);
   ObjectSet("L_Bar1", OBJPROP_CORNER, 1);
   ObjectSet("L_Bar1", OBJPROP_XDISTANCE, 15);
   ObjectSet("L_Bar1", OBJPROP_YDISTANCE, 55);
   ObjectSetText("L_Bar1","------------------------------------------", 12,font,BaseColor);

   // Spread
   ObjectCreate("L_Spread", OBJ_LABEL, 0, 0, 0);
   ObjectSet("L_Spread", OBJPROP_CORNER, 1);
   ObjectSet("L_Spread", OBJPROP_XDISTANCE,70);
   ObjectSet("L_Spread", OBJPROP_YDISTANCE,65);
   ObjectSetText("L_Spread","spread : ", 12, font, TextColor);
   
   ObjectCreate("Spread", OBJ_LABEL, 0, 0, 0);
   ObjectSet("Spread", OBJPROP_CORNER, 1);
   ObjectSet("Spread", OBJPROP_XDISTANCE, 15);
   ObjectSet("Spread", OBJPROP_YDISTANCE, 68);
 
   // +----------------------------------
   ObjectCreate("L_Bar2", OBJ_LABEL, 0, 0, 0);
   ObjectSet("L_Bar2", OBJPROP_CORNER, 1);
   ObjectSet("L_Bar2", OBJPROP_XDISTANCE, 15);
   ObjectSet("L_Bar2", OBJPROP_YDISTANCE, 78);
   ObjectSetText("L_Bar2","------------------------------------------", 12, font, BaseColor);
   
   // High of Day
   ObjectCreate("L_HOD", OBJ_LABEL, 0, 0, 0);
   ObjectSet("L_HOD", OBJPROP_CORNER, 1);
   ObjectSet("L_HOD", OBJPROP_XDISTANCE, 160);
   ObjectSet("L_HOD", OBJPROP_YDISTANCE, 90);
   ObjectSetText("L_HOD","HOD  ", 12, font, BaseColor);

   ObjectCreate("HOD", OBJ_LABEL, 0, 0, 0);
   ObjectSet("HOD", OBJPROP_CORNER, 1);
   ObjectSet("HOD", OBJPROP_XDISTANCE, 70);
   ObjectSet("HOD", OBJPROP_YDISTANCE, 90);

   ObjectCreate("HOD_BID", OBJ_LABEL, 0, 0, 0);
   ObjectSet("HOD_BID", OBJPROP_CORNER, 1);
   ObjectSet("HOD_BID", OBJPROP_XDISTANCE, 15);
   ObjectSet("HOD_BID", OBJPROP_YDISTANCE, 90);

   // Low of Day
   ObjectCreate("L_LOD", OBJ_LABEL, 0, 0, 0);
   ObjectSet("L_LOD", OBJPROP_CORNER, 1);
   ObjectSet("L_LOD", OBJPROP_XDISTANCE, 160);
   ObjectSet("L_LOD", OBJPROP_YDISTANCE, 110);
   ObjectSetText("L_LOD","LOD  ", 12, font, BaseColor);

   ObjectCreate("LOD", OBJ_LABEL, 0, 0, 0);
   ObjectSet("LOD", OBJPROP_CORNER, 1);
   ObjectSet("LOD", OBJPROP_XDISTANCE, 70);
   ObjectSet("LOD", OBJPROP_YDISTANCE, 110);

   ObjectCreate("LOD_BID", OBJ_LABEL, 0, 0, 0);
   ObjectSet("LOD_BID", OBJPROP_CORNER, 1);
   ObjectSet("LOD_BID", OBJPROP_XDISTANCE, 15);
   ObjectSet("LOD_BID", OBJPROP_YDISTANCE, 110);

   // Total Daily Range
   ObjectCreate("L_TDR", OBJ_LABEL, 0, 0, 0);
   ObjectSet("L_TDR", OBJPROP_CORNER, 1);
   ObjectSet("L_TDR", OBJPROP_XDISTANCE, 70);
   ObjectSet("L_TDR", OBJPROP_YDISTANCE, 135);
   ObjectSetText("L_TDR","TDR : ", 12, font, BaseColor);

   ObjectCreate("TDR", OBJ_LABEL, 0, 0, 0);
   ObjectSet("TDR", OBJPROP_CORNER, 1);
   ObjectSet("TDR", OBJPROP_XDISTANCE, 15);
   ObjectSet("TDR", OBJPROP_YDISTANCE, 130);

   // Yearly Daily Range
   ObjectCreate("L_YDR", OBJ_LABEL, 0, 0, 0);
   ObjectSet("L_YDR", OBJPROP_CORNER, 1);
   ObjectSet("L_YDR", OBJPROP_XDISTANCE, 70);
   ObjectSet("L_YDR", OBJPROP_YDISTANCE, 155);
   ObjectSetText("L_YDR","YDR : ", 12, font, BaseColor);

   ObjectCreate("YDR", OBJ_LABEL, 0, 0, 0);
   ObjectSet("YDR", OBJPROP_CORNER, 1);
   ObjectSet("YDR", OBJPROP_XDISTANCE, 15);
   ObjectSet("YDR", OBJPROP_YDISTANCE, 155);

   // Weekly Average Daily Range
   ObjectCreate("L_WADR", OBJ_LABEL, 0, 0, 0);
   ObjectSet("L_WADR", OBJPROP_CORNER, 1);
   ObjectSet("L_WADR", OBJPROP_XDISTANCE, 70);
   ObjectSet("L_WADR", OBJPROP_YDISTANCE, 175);
   ObjectSetText("L_WADR","WADR : ", 12, font, BaseColor);

   ObjectCreate("WADR", OBJ_LABEL, 0, 0, 0);
   ObjectSet("WADR", OBJPROP_CORNER, 1);
   ObjectSet("WADR", OBJPROP_XDISTANCE, 15);
   ObjectSet("WADR", OBJPROP_YDISTANCE, 175);

   // Monthly Average Daily Range
   ObjectCreate("L_MADR", OBJ_LABEL, 0, 0, 0);
   ObjectSet("L_MADR", OBJPROP_CORNER, 1);
   ObjectSet("L_MADR", OBJPROP_XDISTANCE, 70);
   ObjectSet("L_MADR", OBJPROP_YDISTANCE, 195);
   ObjectSetText("L_MADR","MADR : ", 12, font, BaseColor);

   ObjectCreate("MADR", OBJ_LABEL, 0, 0, 0);
   ObjectSet("MADR", OBJPROP_CORNER, 1);
   ObjectSet("MADR", OBJPROP_XDISTANCE, 15);
   ObjectSet("MADR", OBJPROP_YDISTANCE, 195);

   // Half-Yearly Average Daily Range
   ObjectCreate("L_HYADR", OBJ_LABEL, 0, 0, 0);
   ObjectSet("L_HYADR", OBJPROP_CORNER, 1);
   ObjectSet("L_HYADR", OBJPROP_XDISTANCE, 70);
   ObjectSet("L_HYADR", OBJPROP_YDISTANCE, 215);
   ObjectSetText("L_HYADR","HYADR : ", 12, font, BaseColor);

   ObjectCreate("HYADR", OBJ_LABEL, 0, 0, 0);
   ObjectSet("HYADR", OBJPROP_CORNER, 1);
   ObjectSet("HYADR", OBJPROP_XDISTANCE, 15);
   ObjectSet("HYADR", OBJPROP_YDISTANCE, 215);

   // +----------------------------------
   ObjectCreate("L_Bar3", OBJ_LABEL, 0, 0, 0);
   ObjectSet("L_Bar3", OBJPROP_CORNER, 1);
   ObjectSet("L_Bar3", OBJPROP_XDISTANCE, 15);
   ObjectSet("L_Bar3", OBJPROP_YDISTANCE, 230);
   ObjectSetText("L_Bar3","------------------------------------------",12,font,BaseColor);

   // Selected CurrencyPair Chart Name
   ObjectCreate("L_CurrencyPair", OBJ_LABEL, 0, 0, 0);
   ObjectSet("L_CurrencyPair", OBJPROP_CORNER, 1);
   ObjectSet("L_CurrencyPair", OBJPROP_XDISTANCE, 55);
   ObjectSet("L_CurrencyPair", OBJPROP_YDISTANCE, 250);
   ObjectSetText("L_CurrencyPair", instr, 13, font, clrYellow);

   ObjectCreate("Currency Pair", OBJ_LABEL, 0, 0, 0);
   ObjectSet("Currency Pair", OBJPROP_CORNER, 1);
   ObjectSet("Currency Pair", OBJPROP_XDISTANCE, 15);
   ObjectSet("Currency Pair", OBJPROP_YDISTANCE,250);
   ObjectSetText("Currency Pair", sper, 13, font, clrYellow);
                   
   if (Digits == 5) {
      k = 10000; d = 5;
   } else if (Digits == 4) {
      k = 10000; d = 4;
   } else if (Digits == 3) {
      k = 100; d = 3;
   } else if (Digits == 2) {
      k = 10; d = 2;
   } else {
      k = 100; d = 2;
   }

   return(0);
}

//+------------------------------------------------------------------+

int deinit()
{
   ObjectDelete("L_AskPrice");
   ObjectDelete("Ask Price");
   ObjectDelete("L_BidPrice");
   ObjectDelete("Bid Price");
   ObjectDelete("L_Bar1");
   ObjectDelete("L_Spread");
   ObjectDelete("Spread");
   ObjectDelete("L_Bar2");
   ObjectDelete("L_HOD");
   ObjectDelete("HOD");   
   ObjectDelete("HOD_BID");
   ObjectDelete("L_LOD");
   ObjectDelete("LOD");
   ObjectDelete("LOD_BID");
   ObjectDelete("L_TDR");
   ObjectDelete("TDR");
   ObjectDelete("L_YDR");
   ObjectDelete("YDR");
   ObjectDelete("L_WADR");
   ObjectDelete("WADR");
   ObjectDelete("L_MADR");
   ObjectDelete("MADR");
   ObjectDelete("L_HYADR");
   ObjectDelete("HYADR");
   ObjectDelete("L_CurrencyPair");
   ObjectDelete("Currency Pair");

   return(0);
}
 
//+------------------------------------------------------------------+

int start()
{
   //--------- Info settings ------------------ 
   ssprd          = DoubleToStr((Ask-Bid)*k, 1);
   double hod     = iHigh(Symbol(), PERIOD_D1, 0);
   double hod_bid = DoubleToStr((hod - Bid) * k, 0);
   double lod     = iLow(Symbol(), PERIOD_D1, 0);
   double lod_bid = DoubleToStr((Bid - lod) * k, 0);
   string tdr     = DoubleToStr((hod-lod)*k, 0);
   string ydr     = DoubleToStr(GetYDR()*k, 0);
   string wadr    = DoubleToStr(GetWADR()*k, 0);
   string madr    = DoubleToStr(GetMADR()*k, 0);
   string hyadr   = DoubleToStr(GetHYADR()*k, 0);

   ObjectSetText("Ask Price", DoubleToStr(Ask,d-1), 16, "Digifacewide", clrDarkGray);   
   ObjectSetText("Bid Price", DoubleToStr(Bid,d-1), 16, "Digifacewide", clrBlack);
   ObjectSetText("Spread", ssprd, 10, font, clrLimeGreen);
   ObjectSetText("HOD", DoubleToStr(hod, 4) + " : ", 12, font, clrBlack);
   ObjectSetText("HOD_BID", hod_bid, 12, font, clrBlack);   
   ObjectSetText("LOD", DoubleToStr(lod, 4) + " : ", 12, font, clrBlack);
   ObjectSetText("LOD_BID", lod_bid, 12, font, clrBlack);
   ObjectSetText("TDR", tdr, 16, "Digifacewide", clrBlack);
   ObjectSetText("YDR", ydr, 12, font, clrBlack);
   ObjectSetText("WADR", wadr, 12, font, clrBlack);
   ObjectSetText("MADR", madr, 12, font, clrBlack);
   ObjectSetText("HYADR", hyadr, 12, font, clrBlack);

   return(0);
}

// Calculate YDR
double GetYDR()
{
   double totalRange = 0.0;
   int numDays = CountAllDays(Year(), TO_YEAR);
   //Print("All Trading days from Now: ", numDays);
   
   for (int i = 0; i < numDays; i++) {
      double highestHigh = iHigh(Symbol(), PERIOD_D1, i);
      double lowestLow = iLow(Symbol(), PERIOD_D1, i);
      double tdr = highestHigh - lowestLow;
      totalRange += tdr;
   }
   
   double ydr = totalRange / numDays;
   return ydr;
}

// Calculate WADR
double GetWADR()
{
   double totalRange = 0.0;
   int numDays = 0;
   string date = "";

   int currentDayOfWeek = TimeDayOfWeek(TimeCurrent());
   //Print("Current day of the week: ", currentDayOfWeek, Day());
   if (currentDayOfWeek == 0) {
      date = IntegerToString(Year()) + "." + IntegerToString(Month()) + "." + IntegerToString(Day() - 7);
      numDays = CountAllDays(date, TO_DAY);
   } else {
      date = IntegerToString(Year()) + "." + IntegerToString(Month()) + "." + IntegerToString(Day() - currentDayOfWeek);
      numDays = CountAllDays(date, TO_DAY);
   }
   //Print("All Trading days from Now: ", numDays);

   for (int i = 0; i < numDays; i++) {
      datetime previousDayTime = iTime(Symbol(), PERIOD_D1, i + 1);
      //Print("Timestamp of the previous bar: ", TimeToStr(previousDayTime, TIME_DATE));
      int numberOfBars = iBars(Symbol(), PERIOD_D1) - iBarShift(Symbol(), PERIOD_D1, previousDayTime);
      //Print("Number of bars for the previous ", i + 1, " day: ", numberOfBars);

      double atr = iATR(Symbol(), PERIOD_D1, numberOfBars, i);
      totalRange += atr;
   }
   double wadr = totalRange / numDays;
   return wadr;
}

// Calculate MADR
double GetMADR()
{
   double totalRange = 0.0;
   string month = IntegerToString(Year()) + "." + IntegerToString(Month());
   int numDays = CountAllDays(month, TO_MONTH);
   //Print("All Trading days from Now: ", numDays);

   for (int i = 0; i < numDays; i++) {
      double atr = iATR(Symbol(), PERIOD_D1, 12, i);
      totalRange += atr;
   }
   
   double madr = totalRange / numDays;
   return madr;
}

// Calculate HYADR
double GetHYADR()
{
   double totalRange = 0.0;
   int numDays = CountAllDays(Year(), TO_YEAR);
   //Print("All Trading days from Now: ", numDays);
 
   for (int i = 0; i < numDays; i++) {
      datetime previousDayTime = iTime(Symbol(), PERIOD_D1, i + 1);
      //Print("Timestamp of the previous bar: ", TimeToStr(previousDayTime, TIME_DATE));
      int numberOfBars = iBars(Symbol(), PERIOD_D1) - iBarShift(Symbol(), PERIOD_D1, previousDayTime);
      //Print("Number of bars for the previous ", i + 1, " day: ", numberOfBars);
      double atr = iATR(Symbol(), PERIOD_D1, numberOfBars, i);
      totalRange += atr;
   }
   
   double hyadr = totalRange / numDays;
   return hyadr;
}

// Calculate All Trading Days from the given Data Range
int CountAllDays(string datevalue, int limit)
{
   int count = 0;
   
   datetime startDate = 0;
   switch(DATERANGE) {
      case TO_YEAR:
         startDate = StrToTime(datevalue + ".01.01");
         break;
      case TO_MONTH:
         startDate = StrToTime(datevalue + ".01");
         break;
      case TO_DAY:
         startDate = StrToTime(datevalue);
         break;
   }
   datetime endDate = StrToTime(TimeCurrent());
   
   //Print("Start Date ", TimeToStr(startDate, TIME_DATE));
   //Print("End Date ", TimeToStr(endDate, TIME_DATE));
   
   for (datetime currentDay = startDate; currentDay <= endDate; currentDay += 86400) {
      int dayOfWeek = TimeDayOfWeek(currentDay);
      if (dayOfWeek != 0 && dayOfWeek != 6)  // Exclude Saturday (0) and Sunday (6)
         count++;
   }
   
   return count;
}