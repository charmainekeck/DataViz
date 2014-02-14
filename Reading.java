public class Reading
{
  private long time;
  private int subject, ventilatorRate, pip, peep;
  private float pH, fiO2, weight;
  private String site, ventMode;

  Reading(int subject, String site, int ventilatorRate, int pip, int peep, float pH, float fiO2, float weight, String ventMode, long time) {
    this.subject = subject;
    this.site = site;
    this.ventilatorRate = ventilatorRate;
    this.pip = pip;
    this.peep = peep;
    this.pH = pH;
    this.fiO2 = fiO2;
    this.weight = weight;
    this.ventMode = ventMode;
    this.time = time;
  }

  public long getTime()
  {
    return time;
  }

  public int getVentilatorRate() {
    return ventilatorRate;
  }

  public int getPip() {
    return pip;
  }

  public int getPeep() {
    return peep;
  }

  public float getpH() {
    return pH;
  }

  public float getFiO2() {
    return fiO2;
  }

  public float getWeight() {
    return weight;
  }

  public String getSite() {
    return site;
  }
  public int getSubject(){
    return subject;
  }

  public String getVentMode() {
    return ventMode;
  }

  public String toString()
  {
    return "[time: " + time + ",  ventRate: " + ventilatorRate + ",  pip: " + pip + ",  peep: " + peep + ",  pH: " + pH + ",  FiO2: " + fiO2 + ",  weight: " + weight + ",  ventMode: " + ventMode + "]";
  }
}
