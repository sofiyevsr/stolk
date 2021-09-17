import { Chart } from "react-google-charts";

type Props = {
  title: string;
  data: (string | number)[][];
  header: string[];
  absolute?: boolean;
  options?: { [key: string]: any };
};

function TableChart({ options, title, header, data, absolute }: Props) {
  return (
    <Chart
      chartType="Table"
      loader={<div>Loading Chart</div>}
      style={
        absolute
          ? { position: "absolute", top: 0, right: 0, zIndex: 100 }
          : undefined
      }
      data={[header, ...data]}
      options={{
        title,
        ...options,
      }}
    />
  );
}

export default TableChart;
