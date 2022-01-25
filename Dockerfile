FROM mbradle/docker_wn_user

ENV NAME VAR
ENV NAME OUT_DIR
ENV NAME OUT_FILE
ENV NAME HEADER_COPY_DIRECTORY

ARG WN_USER
ENV WN_USER=$WN_USER

WORKDIR /my-projects

RUN git -C ${WN_USER_TARGET} pull

WORKDIR /my-projects/wn_user

WORKDIR /my-projects

RUN git clone https://mbradle@bitbucket.org/mbradle/graph_flows.git

WORKDIR /my-projects/graph_flows

COPY Dockerfile master.[h] /my-projects/graph_flows/

RUN make graph_flows

CMD \
  if [ "$HEADER_COPY_DIRECTORY" ]; then \
    cp /my-projects/graph_flows/default/master.h ${HEADER_COPY_DIRECTORY}/master.h; \
  else \
      if [ "$OUT_DIR" ]; then \
          rm -fr $OUT_DIR ;\
          mkdir -p $OUT_DIR ;\
          ./graph_flows $VAR --graph_output_base $OUT_DIR/out ;\
          ./flow_graph.sh $OUT_DIR ;\
          if [ "$OUT_FILE" ]; then \
             ./combine_graphs.sh $OUT_DIR $OUT_FILE ; \
          fi \
      else \
          rm -fr /output_directory/flows ;\
          mkdir -p /output_directory/flows ;\
          ./graph_flows $VAR --graph_output_base /output_directory/flows/out ;\
          ./flow_graph.sh /output_directory/flows ;\
          if [ "$OUT_FILE" ]; then \
             ./combine_graphs.sh /output_directory/flows $OUT_FILE ; \
          fi \
      fi \
  fi
