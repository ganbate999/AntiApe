import styled, { css } from "styled-components";

export const Container = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 30px 20px;
  color: white;
  min-height: 100vh;

  @media (min-width: 768px) {
    padding: 20px;
  }

  @media (min-width: 993px) {
    padding: 50px 30px;
  }
`;

export const InnerContainer = styled.div`
  display: flex;
  flex-direction: column;
  width: 100%;
  height: 100%;

  @media (min-width: 768px) {
    flex-direction: row;
    width: 90%;
  }

  @media (min-width: 1024px) {
    width: 85%;
    max-width: 1500px;
    margin: 0 auto;
  }
`;

export const TextWrapper = styled.div`
  width: 100%;
  padding-right: 0px;
  margin-bottom: 30px;

  > h1 {
    font-weight: bold;
    font-size: 36px;
    color: white;
  }

  > h2 {
    font-size: 28px;
    font-style: italic;
    font-weight: bold;
    padding-left: 20px;
    color: white;
  }

  @media (min-width: 768px) {
    padding-right: 20px;
    width: 50%;
    margin-bottom: 0px;

    > h1 {
      font-size: 45px;
    }

    > h2 {
      padding-left: 50px;
      font-size: 36px;
    }
  }

  @media (min-width: 1024px) {
    > h1 {
      font-size: 57px;
    }

    > h2 {
      font-size: 52px;
    }
  }

  @media (min-width: 1200px) {
    > h1 {
      font-size: 68px;
    }

    > h2 {
      font-size: 62px;
    }
  }

  @media (min-width: 1440px) {
    > h1 {
      font-size: 82px;
      line-height: 106px;
    }

    > h2 {
      font-size: 72px;
    }
  }
`;

export const NFTContainer = styled.div`
  p {
    font-weight: 300;
    font-size: 24px;
    margin: 0px;
  }
  padding-left: 20px;

  @media (min-width: 768px) {
    padding-left: 40px;
    p {
      font-size: 28px;
    }
  }

  @media (min-width: 1024px) {
    padding-left: 40px;
    p {
      font-size: 32px;
    }
  }

  @media (min-width: 1440px) {
    p {
      font-size: 36px;
    }
  }
`;

export const StepWrapper = styled.div``;

export const ButtonWrapper = styled.div`
  margin-top: 130px;
  padding-left: 20px;

  button {
    background: #f6560f;
    box-shadow: 0px 2px 4px rgba(0, 0, 0, 0.25);
    border-radius: 30px;
    width: 169px;
    height: 49px;
    border: 1px solid #f6560f;
    transition: all 0.3s linear;
    color: white;
    font-size: 20px;
    cursor: pointer;

    &:hover {
      background: transparent;
      border: 1px solid #f6560f;
      color: #f6560f;
    }
  }

  @media (min-width: 768px) {
    padding-left: 40px;
  }
`;

export const ImgWrapper = styled.div`
  width: 100%;
  margin: 30px 0;

  > img {
    width: 100%;
  }

  @media (min-width: 768px) {
    margin: 0;
    display: flex;
    align-items: center;
    padding-left: 20px;
    width: 50%;
  }
`;

export const ProgressBarContainer = styled.ul`
  padding: 0px;
  width: 100%;
  margin-top: -4px;

  @media (min-width: 768px) {
    margin-top: -8px;
  }
`;

export const PointWrapper = styled.li`
  list-style-type: none;
  width: 25%;
  float: left;
  position: relative;
  background: rgba(66, 63, 81, 0.55);

  &:first-child {
    border-top-left-radius: 15px;
    border-bottom-left-radius: 15px;
  }

  &:last-child {
    border-top-right-radius: 15px;
    border-bottom-right-radius: 15px;
  }

  &::before {
    content: "";
    counter-increment: step;
    display: block;
    text-align: center;
    margin: 20px auto 20px auto;
    border-radius: 50%;
    width: 30px;
    height: 30px;
    min-width: 30px;
    box-sizing: border-box;
    border: 5px solid #c4c4c4;
    background: #c4c4c4;
  }

  &:not(:first-child)::after {
    width: 100%;
    height: 4px;
    content: "";
    position: absolute;
    background-color: #c4c4c4;
    top: 33px;
    left: -50%;
    z-index: -1;
  }

  ${({ active }) =>
    active &&
    css`
      &::before {
        background: #f6560f;
        border: 5px solid #f6560f;
      }
      &:not(:first-child)::after {
        background-color: #f6560f;
      }
    `}
`;
