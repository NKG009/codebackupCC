/* eslint-disable no-undef */
import { LightningElement, api } from "lwc";
import SITE_ASSETS from "@salesforce/resourceUrl/portalV2Assets";
import { loadScript } from "lightning/platformResourceLoader";

export default class StandaloneDatePicker extends LightningElement {
  moment = SITE_ASSETS + "/js/moment.min.js";

  today;

  lastClass;
  dateContext;

  @api
  defaultSelectedDate;
  dateRangeValue;
  @api
  defaultSelectedValues;

  selectedStartDate;
  selectedEndDate;
  currentMonth;
  year;

  weeks = [];

  selectingStartDate = true;

  @api
  get dateRange() {
    return this.dateRangeValue;
  }
  set dateRange(value) {
    this.dateRangeValue = value === "true";
  }

  get formattedSelectedDate() {
    loadScript(this, this.moment).then(() => {
      console.log(this.selectedStartDate.format("YYYY-MM-DD"));
      return this.selectedStartDate.format("YYYY-MM-DD");
    });
    return undefined;
  }

  previousMonth() {
    loadScript(this, this.moment).then(() => {
      this.dateContext = moment(this.dateContext).subtract(1, "month");
      this.refreshDateNodes();
      this.currentMonth = this.dateContext.format("MMMM");
      this.year = this.dateContext.format("Y");
    });
  }

  nextMonth() {
    loadScript(this, this.moment).then(() => {
      this.dateContext = moment(this.dateContext).add(1, "month");
      this.refreshDateNodes();
      this.currentMonth = this.dateContext.format("MMMM");
      this.year = this.dateContext.format("Y");
    });
  }

  goToday() {
    this.dateContext = this.today;
    this.currentMonth = this.dateContext.format("MMMM");
    this.year = this.dateContext.format("Y");
    this.refreshDateNodes();
  }

  @api
  setSelected(e) {
    loadScript(this, this.moment).then(() => {
      if (!this.dateRange || this.selectingStartDate) {
        this.dispatchEvent(
          new CustomEvent("dateselect", {
            detail: undefined
          })
        );
        this.dispatchEvent(
          new CustomEvent("dateselectend", {
            detail: undefined
          })
        );

        const selectedDate =
          this.template.querySelectorAll(".slds-is-selected");
        selectedDate.forEach((node) => {
          node.className = "date";
          const { date } = node.dataset;
          if (date === this.today.format("YYYY-MM-DD")) {
            node.className = "slds-is-today";
          }
        });

        const { date } = e.target.dataset;
        console.log(JSON.stringify(e.target.dataset));
        this.selectedStartDate = moment(date);
        // this.dateContext = moment(date);
        this.lastClass = e.target.parentNode.className;
        e.target.parentNode.className =
          "slds-is-selected slds-is-selected-multi";
        this.dispatchEvent(
          new CustomEvent("dateselect", {
            detail: this.selectedStartDate.format("YYYY-MM-DD")
          })
        );
        this.selectingStartDate = false;
      } else if (this.dateRange && !this.selectingStartDate) {
        const { date } = e.target.dataset;
        console.log(JSON.stringify(e.target.dataset));
        this.selectedEndDate = moment(date);
        // this.dateContext = moment(date);
        this.lastClass = e.target.parentNode.className;
        e.target.parentNode.className =
          "slds-is-selected slds-is-selected-multi";

        let daysBetweenStartEnd = this.selectedEndDate.diff(
          this.selectedStartDate,
          "days"
        );
        if (daysBetweenStartEnd < 0) {
          const startDate = this.selectedStartDate.format("YYYY-MM-DD");
          this.selectedStartDate = this.selectedEndDate;
          this.selectedEndDate = moment(startDate);
          daysBetweenStartEnd = Math.abs(daysBetweenStartEnd);

          this.dispatchEvent(
            new CustomEvent("dateselect", {
              detail: this.selectedStartDate.format("YYYY-MM-DD")
            })
          );
        }

        console.log(daysBetweenStartEnd);
        for (let i = 0; i < daysBetweenStartEnd; i++) {
          const nextDate = moment(
            this.selectedStartDate.format("YYYY-MM-DD")
          ).add(i, "days");
          const currentDateNode = this.template.querySelector(
            `span[data-date='${nextDate.format("YYYY-MM-DD")}']`
          );
          console.log(nextDate.format("YYYY-MM-DD"));
          if (currentDateNode) {
            currentDateNode.parentNode.className =
              "slds-is-selected slds-is-selected-multi";
          }
        }
        this.dispatchEvent(
          new CustomEvent("dateselectend", {
            detail: this.selectedEndDate.format("YYYY-MM-DD")
          })
        );
        this.selectingStartDate = true;
      }
    });
  }

  @api
  reset() {
    loadScript(this, this.moment).then(() => {
      const selectedDate = this.template.querySelectorAll(".slds-is-selected");
      selectedDate.forEach((node) => {
        node.className = "date";
        const { date } = node.dataset;
        if (date === this.today.format("YYYY-MM-DD")) {
          node.className = "slds-is-today";
        }
      });
      this.selectedStartDate = undefined;
      this.selectedEndDate = undefined;
      this.dispatchEvent(
        new CustomEvent("dateselect", {
          detail: undefined
        })
      );
      this.dispatchEvent(
        new CustomEvent("dateselectend", {
          detail: undefined
        })
      );
    });
  }

  refreshDateNodes() {
    let weeks = [];
    // startOf mutates this.moment, hence clone before use
    const start = this.dateContext.clone().startOf("month").startOf("week");
    const end = this.dateContext.clone().endOf("month").endOf("week");
    const days = end.diff(start, "days");
    console.log(days);

    for (let i = 0; i <= days; i++) {
      const day = start.clone().add(i, "day");
      let selectedWeek = weeks.find((week) => {
        return week.week === day.week();
      });

      //create the week if one doesnt exist
      if (!selectedWeek) {
        weeks.push({
          week: day.week(),
          days: []
        });

        selectedWeek = weeks[weeks.length - 1];
      }
      let className = "date";

      if (day.month() === this.dateContext.month()) {
        if (day.isSame(this.today, "day")) {
          className = "slds-is-today";
        }
        if (
          this.selectedStartDate &&
          this.selectedEndDate &&
          (day.isSame(this.selectedStartDate, "day") ||
            day.isSame(this.selectedEndDate, "day") ||
            day.isBetween(this.selectedStartDate, this.selectedEndDate))
        ) {
          if (this.dateRange) {
            className = "slds-is-selected slds-is-selected-multi";
          } else {
            className = "slds-is-selected";
          }
        }
      } else {
        if (day.isSame(this.today, "day")) {
          className = "slds-is-today";
        }
        if (
          this.selectedStartDate &&
          this.selectedEndDate &&
          (day.isSame(this.selectedStartDate, "day") ||
            day.isSame(this.selectedEndDate, "day") ||
            day.isBetween(this.selectedStartDate, this.selectedEndDate))
        ) {
          if (this.dateRange) {
            className = "slds-is-selected slds-is-selected-multi";
          } else {
            className = "slds-is-selected";
          }
        } else {
          className = "slds-day_adjacent-month";
        }
      }
      selectedWeek.days.push({
        className: className,
        formatted: day.format("YYYY-MM-DD"),
        text: day.format("DD")
      });
    }

    this.weeks = weeks;
    console.log(this.weeks);
  }

  connectedCallback() {
    loadScript(this, this.moment).then(() => {
      this.today = moment();

      if (!this.dateRange) {
        this.dateContext =
          this.defaultSelectedDate === undefined
            ? moment()
            : moment(this.defaultSelectedDate);
        this.currentMonth = this.dateContext.format("MMMM");
        this.selectedStartDate =
          this.defaultSelectedDate === undefined
            ? moment()
            : moment(this.defaultSelectedDate);
        this.selectedEndDate =
          this.defaultSelectedDate === undefined
            ? moment()
            : moment(this.defaultSelectedDate);
        this.dateContext.format("Y");
        console.log(this.today);
      } else {
        this.dateContext =
          this.defaultSelectedValues === undefined
            ? moment()
            : moment(this.defaultSelectedValues.filterTerms.startDate);
        this.currentMonth = this.dateContext.format("MMMM");
        this.dateContext.format("Y");

        this.selectedStartDate =
          this.defaultSelectedValues === undefined
            ? undefined
            : moment(this.defaultSelectedValues.filterTerms.startDate);
        this.selectedEndDate =
          this.defaultSelectedValues === undefined
            ? undefined
            : moment(this.defaultSelectedValues.filterTerms.endDate);
      }
      this.refreshDateNodes();
    });
  }
}