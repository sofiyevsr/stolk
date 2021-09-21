import { Chart } from "react-google-charts";

type Props = {
  title: string;
  data: (string | number)[][];
  header: string[];
};

function PieChart({ title, header, data }: Props) {
  return (
    <Chart
      chartType="PieChart"
      loader={<div>Loading Chart</div>}
      data={[header, ...data]}
      options={{
        height: 400,
        title,
      }}
    />
  );
}

export default PieChart;
