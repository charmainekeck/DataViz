import java.util.*;

public class Patient
{
  private static final String SITEHEADER = "Site";
  private static final String VENTILATORRATEHEADER = "VentilatorRate";
  private static final String PIPHEADER = "PIP";
  private static final String PEEPHEADER = "PEEP";
  private static final String PHHEADER = "pH";
  private static final String FIO2HEADER = "FiO2";
  private static final String WEIGHTHEADER = "Weight";
  private static final String VENTMODEHEADER = "VentMode";
  private static final String VENTTIMEHEADER = "VentTime";
  private static final String VENTDATEHEADER = "VentDate";

  private int startHr, startMin, startSec;

  private int siteID, ventilatorRateID, pipID, peepID, phID, fio2ID, weightID, ventModeID, ventDateID, ventTimeID;
  private ArrayList<Reading> readings;

  Patient(String[] headers) {
    readings = new ArrayList<Reading>();

    for (int id = 0; id < headers.length; id++) {
      String header = headers[id];
      if (header.equals(SITEHEADER))
        siteID = id;
      else if (header.equals(VENTILATORRATEHEADER))
        ventilatorRateID = id;
      else if (header.equals(PIPHEADER))
        pipID = id;
      else if (header.equals(PEEPHEADER))
        peepID = id;
      else if (header.equals(PHHEADER))
        phID = id;
      else if (header.equals(FIO2HEADER))
        fio2ID = id;
      else if (header.equals(WEIGHTHEADER))
        weightID = id;
      else if (header.equals(VENTMODEHEADER))
        ventModeID = id;
      else if (header.equals(VENTTIMEHEADER))
        ventTimeID = id;
      else if (header.equals(VENTDATEHEADER))
        ventDateID = id;
    }
  }

  void addDataRow(String[] data) {
    int ventDate = -1;
    try {
      ventDate = Integer.parseInt(data[ventDateID]);
    } catch (ArrayIndexOutOfBoundsException e) {
      return;
    } catch (NumberFormatException e) {}

    String ventTime = data[ventTimeID];

    // We need valid dates in order to graph
    if (ventDate < 0 || ventTime.split(":").length != 3)
      return;

    long time = getElapsedTime(ventDate, ventTime);

    String site = data[siteID];
    String ventMode = data[ventModeID];
    int ventilatorRate = parseIntData(data[ventilatorRateID]);
    int pip = parseIntData(data[pipID]);
    int peep = parseIntData(data[peepID]);
    float pH = parseFloatData(data[phID]);
    float fiO2 = parseFloatData(data[fio2ID]);
    float weight = parseFloatData(data[weightID]);

    readings.add(new Reading(site, ventilatorRate, pip, peep, pH, fiO2, weight, ventMode, time));
  }

  public Reading[] getReadings()
  {
    Collections.sort(readings, new EllapsedTimeComparator());
    Reading[] retVal = new Reading[readings.size()];
    for (int i = 0; i < readings.size(); i++) {
      retVal[i] = readings.get(i);
    }
    return retVal;
  }

  public long getMaxTime()
  {
    if (readings.size() == 0)
      return 0L;

    Collections.sort(readings, new EllapsedTimeComparator());
    return readings.get(readings.size() - 1).getTime();
  }

  public long getStartTime()
  {
    if (readings.size() == 0)
      return 0L;

    Collections.sort(readings, new EllapsedTimeComparator());
    return readings.get(0).getTime();
  }

  public String toString()
  {
    String pString = "Patient- " + readings.size()  + " readings, ";
    pString += "startTime: " + getStartTime() + ", maxTime: " + getMaxTime() + "\n[";
    for (Reading r : readings) {
      pString += r.toString();
      pString += ",\n";
    }

    return pString;
  }

  private long getElapsedTime(int day, String time)
  {
    long elapsed = 0L;
    String[] hms = time.split(":");
    int hour = Integer.parseInt(hms[0]);
    int min = Integer.parseInt(hms[1]);
    int sec = Integer.parseInt(hms[2]);

    if (readings.size() > 0) {
      elapsed += day * (24*60*60*1000);
      elapsed += (hour - startHr) * (60*60*1000);
      elapsed += (min - startMin) * (60*1000);
      elapsed += (sec - startSec) * (1000);
    } else {
      startHr = hour;
      startMin = min;
      startSec = sec;
    }

    return elapsed;
  }

  private int parseIntData(String data)
  {
    int parsedData = -1;
    try {
      parsedData = Integer.parseInt(data);
    } catch (NumberFormatException e) {}
    return parsedData;
  }

  private float parseFloatData(String data)
  {
    float parsedData = -1;
    try {
      parsedData = Float.parseFloat(data);
    } catch (NumberFormatException e) {}
    return parsedData;
  }

  private class EllapsedTimeComparator implements Comparator<Reading> {
      public int compare(Reading r1, Reading r2) {
          return (int)(r1.getTime() - r2.getTime());
      }
  }
}
