import { FC } from "react";
import { Row, Col } from "../../../widgets";
import cover1 from "../../../utils/images/img26.jpg";
import cover2 from "../../../utils/images/img28.jpg";
import cover3 from "../../../utils/images/img31.jpg";
import cover4 from "../../../utils/images/img34.jpg";
import cover5 from "../../../utils/images/img5.jpg";
import groupimg1 from "../../../utils/images/img11.jpg";
import groupimg2 from "../../../utils/images/img12.jpg";
import groupimg3 from "../../../utils/images/img13.jpg";
import groupimg4 from "../../../utils/images/img14.jpg";
import groupimg5 from "../../../utils/images/img15.jpg";
import groupimg6 from "../../../utils/images/img6.jpg";
import groupimg7 from "../../../utils/images/img20.jpg";
import groupimg8 from "../../../utils/images/img21.jpg";
import groupimg9 from "../../../utils/images/img23.jpg";
import groupimg10 from "../../../utils/images/img24.jpg";
import GroupCard from "../../../components/group-card";

const MainContent: FC = () => {
    return (
        <Col lg={9}>
            <Row gutters={10}>
                <Col sm={6} md={4}>
                    <GroupCard
                        cover={cover1}
                        color="indigo"
                        name="Human Resources"
                        members="1,232,099"
                        isJoined={false}
                        path="#!"
                        images={[
                            groupimg1,
                            groupimg2,
                            groupimg3,
                            groupimg4,
                            groupimg5,
                        ]}
                        connections={9}
                    />
                </Col>
                <Col sm={6} md={4} mt={["10px", 0]}>
                    <GroupCard
                        cover={cover2}
                        color="dark"
                        name="UI Designers World"
                        members="1,055,767"
                        isJoined={false}
                        path="#!"
                        images={[groupimg1, groupimg2, groupimg3]}
                        connections={3}
                    />
                </Col>
                <Col sm={6} md={4} mt={["10px", null, 0]}>
                    <GroupCard
                        cover={cover3}
                        color="dark"
                        name="Backend Developers"
                        members="1,002,005"
                        isJoined
                        path="#!"
                        images={[groupimg6]}
                        connections={1}
                    />
                </Col>
                <Col sm={6} md={4} mt="10px">
                    <GroupCard
                        cover={cover4}
                        color="teal"
                        name="Bootstrap Wizards"
                        members="1,032,292"
                        isJoined={false}
                        path="#!"
                        images={[groupimg1, groupimg2, groupimg3]}
                        connections={3}
                    />
                </Col>
                <Col sm={6} md={4} mt="10px">
                    <GroupCard
                        cover={cover5}
                        color="teal"
                        name="SASS Gurus"
                        members="990,010"
                        isJoined={false}
                        path="#!"
                        images={[groupimg7, groupimg8]}
                        connections={2}
                    />
                </Col>
                <Col sm={6} md={4} mt="10px">
                    <GroupCard
                        cover={cover5}
                        color="dark"
                        name="Android Ninjas"
                        members="988,500"
                        isJoined={false}
                        path="#!"
                        images={[groupimg9, groupimg10]}
                        connections={2}
                    />
                </Col>
                <Col sm={6} md={4} mt="10px">
                    <GroupCard
                        cover={cover5}
                        color="dark"
                        name="React Heroes"
                        members="988,500"
                        isJoined
                        path="#!"
                        images={[groupimg9, groupimg10, groupimg6]}
                        connections={3}
                    />
                </Col>
            </Row>
        </Col>
    );
};

export default MainContent;
