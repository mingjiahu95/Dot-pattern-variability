%%
% training patterns sampled from a pool; fixed for each subject
%   training phase: 27 patterns (3 category) per block
%   with transfer classification phase
%   transfer phase presents the 27 training patterns,
%     27 new high distortions, 3 misclassified high distortions, 9 low distortions,18 medium distortions,
%       and 3 prototypes 


try       
    clear all;
    Screen('Preference', 'SkipSyncTests', 1); 
    data_location=[pwd '\data\'];
    subid=input(' Subject # ');
    cond=input (' Condition # ');

    filename=[data_location 'dot_cond' num2str(cond) '_sub' num2str(subid) '.txt'];
    allvars=[data_location 'dot_cond' num2str(cond) '_sub' num2str(subid)];
    if ~exist('data','dir')
        mkdir('data')
    end
    if ~exist(filename,'file')
        fid=fopen(filename,'wt');
        s_pat=RandStream('mt19937ar','Seed',0);% set seed to be 'Shuffle' for varying dot patterns across subjects
        RandStream.setGlobalStream(s_pat);
        HideCursor;
        KbName('UnifyKeyNames');
        %
        % upload the training and transfer pattern
        
        % define design parameters
        ncat = 3;
        n_old = 9;
        n_newlow = 3;
        n_newmed = 6;
        n_newhigh = 9;
        n_newhigh_hard = 1;
        n_proto = 1;
        ntrain = n_old*ncat;
        ntrans = (n_old+n_newlow+n_newmed+n_newhigh_hard+n_newhigh+n_proto)*ncat;
%         nblock=input(' number of pilot training blocks [15] ');
%         nblocktest=input(' number of pilot test blocks [1] ');
        nblocktrian=10;%10
        nblocktest=1;
        
        % read dot coordinates info
        load('coord_info.mat')
        proto(1,:,:) = p1;
        proto(2,:,:) = p2;
        proto(3,:,:) = p3;

        
        switch cond
            case 1 %low distortion
             % randomize the sampling of dot patterns for each subject
                train_idx(1,:) = randperm(100,n_old);
                train_idx(2,:) = randperm(100,n_old);
                train_idx(3,:) = randperm(100,n_old);
                % read individual pattern coordinates
                for ipat = 1:(n_old)
                    ipat1 = train_idx(1,ipat);
                    ipat2 = train_idx(2,ipat);
                    ipat3 = train_idx(3,ipat);
                    distort_old(1,ipat) = 1;
                    distort_old(2,ipat) = 1;
                    distort_old(3,ipat) = 1;
                    train(1,ipat,:,:) = ld1(:,:,ipat1);
                    train(2,ipat,:,:) = ld2(:,:,ipat2);
                    train(3,ipat,:,:) = ld3(:,:,ipat3);
                end
            case 2 %medium distortion
             train_idx(1,:) = randperm(100,n_old);
             train_idx(2,:) = randperm(100,n_old);
             train_idx(3,:) = randperm(100,n_old);
                for ipat = 1:(n_old)
                    ipat1 = train_idx(1,ipat);
                    ipat2 = train_idx(2,ipat);
                    ipat3 = train_idx(3,ipat);
                    distort_old(1,ipat) = 2;
                    distort_old(2,ipat) = 2;
                    distort_old(3,ipat) = 2;
                    train(1,ipat,:,:) = md1(:,:,ipat1);
                    train(2,ipat,:,:) = md2(:,:,ipat2);
                    train(3,ipat,:,:) = md3(:,:,ipat3);
                end
            case 3 %high distortion
            train_idx(1,:) = randperm(100,n_old);
            train_idx(2,:) = randperm(100,n_old);
            train_idx(3,:) = randperm(100,n_old);
                for ipat = 1:(n_old)
                    ipat1 = train_idx(1,ipat);
                    ipat2 = train_idx(2,ipat);
                    ipat3 = train_idx(3,ipat);
                    distort_old(1,ipat) = 3;
                    distort_old(2,ipat) = 3;
                    distort_old(3,ipat) = 3;
                    train(1,ipat,:,:) = hd1(:,:,ipat1);
                    train(2,ipat,:,:) = hd2(:,:,ipat2);
                    train(3,ipat,:,:) = hd3(:,:,ipat3);
                end
            case 4 %mixed distortions
            train_idx(1,1,:) = randperm(100,n_old/3);
            train_idx(1,2,:) = randperm(100,n_old/3);
            train_idx(1,3,:) = randperm(100,n_old/3);
            train_idx(2,1,:) = randperm(100,n_old/3);
            train_idx(2,2,:) = randperm(100,n_old/3);
            train_idx(2,3,:) = randperm(100,n_old/3);
            train_idx(3,1,:) = randperm(100,n_old/3);
            train_idx(3,2,:) = randperm(100,n_old/3);
            train_idx(3,3,:) = randperm(100,n_old/3);
                for ipat_set = 1:(n_old/3) 
                    ipats = (ipat_set-1)*3 + (1:3);% 
                    ipat_set11 = train_idx(1,1,ipat_set);
                    ipat_set12 = train_idx(1,2,ipat_set);
                    ipat_set13 = train_idx(1,3,ipat_set);
                    ipat_set21 = train_idx(2,1,ipat_set);
                    ipat_set22 = train_idx(2,2,ipat_set);
                    ipat_set23 = train_idx(2,3,ipat_set);
                    ipat_set31 = train_idx(3,1,ipat_set);
                    ipat_set32 = train_idx(3,2,ipat_set);
                    ipat_set33 = train_idx(3,3,ipat_set);
                    distort_old(1,ipats) = [1 2 3];
                    distort_old(2,ipats) = [1 2 3];
                    distort_old(3,ipats) = [1 2 3];
                    train(1,ipats,:,:) = permute(cat(3,ld1(:,:,ipat_set11),md1(:,:,ipat_set12),hd1(:,:,ipat_set13)),[3 1 2]);
                    train(2,ipats,:,:) = permute(cat(3,ld2(:,:,ipat_set21),md2(:,:,ipat_set22),hd2(:,:,ipat_set23)),[3 1 2]);
                    train(3,ipats,:,:) = permute(cat(3,ld3(:,:,ipat_set31),md3(:,:,ipat_set32),hd3(:,:,ipat_set33)),[3 1 2]);
                end
        end

        % make sure test patterns don't overlap with training patterns
        testlow_idx(1,:) = repmat(100,1,n_newlow) + randperm(100,n_newlow);
        testlow_idx(2,:) = repmat(100,1,n_newlow) + randperm(100,n_newlow);
        testlow_idx(3,:) = repmat(100,1,n_newlow) + randperm(100,n_newlow);
        for ipat=1:n_newlow
            ipat1 = testlow_idx(1,ipat);
            ipat2 = testlow_idx(2,ipat);
            ipat3 = testlow_idx(3,ipat);
            testlow(1,ipat,:,:)=ld1(:,:,ipat1);
            testlow(2,ipat,:,:)=ld2(:,:,ipat2);
            testlow(3,ipat,:,:)=ld3(:,:,ipat3);
        end

        testmed_idx(1,:) = repmat(100,1,n_newmed) + randperm(100,n_newmed);
        testmed_idx(2,:) = repmat(100,1,n_newmed) + randperm(100,n_newmed);
        testmed_idx(3,:) = repmat(100,1,n_newmed) + randperm(100,n_newmed);
        for ipat=1:n_newmed
            ipat1 = testmed_idx(1,ipat);
            ipat2 = testmed_idx(2,ipat);
            ipat3 = testmed_idx(3,ipat);
            testmed(1,ipat,:,:)=md1(:,:,ipat1);
            testmed(2,ipat,:,:)=md2(:,:,ipat2);
            testmed(3,ipat,:,:)=md3(:,:,ipat3);
        end

        testhigh_idx(1,:) = repmat(100,1,n_newhigh) + randperm(100,n_newhigh);
        testhigh_idx(2,:) = repmat(100,1,n_newhigh) + randperm(100,n_newhigh);
        testhigh_idx(3,:) = repmat(100,1,n_newhigh) + randperm(100,n_newhigh);
        for ipat=1:n_newhigh
            ipat1 = testhigh_idx(1,ipat);
            ipat2 = testhigh_idx(2,ipat);
            ipat3 = testhigh_idx(3,ipat);
            testhigh(1,ipat,:,:)=hd1(:,:,ipat1);
            testhigh(2,ipat,:,:)=hd2(:,:,ipat2);
            testhigh(3,ipat,:,:)=hd3(:,:,ipat3);
        end 

        testhigh_hard_idx = [126 129 110];        
        testhigh_hard(1,:,:) = hd1(:,:,testhigh_hard_idx(1)); %misclassified as cat C
        testhigh_hard(2,:,:) = hd2(:,:,testhigh_hard_idx(2)); %misclassified as cat A
        testhigh_hard(3,:,:) = hd3(:,:,testhigh_hard_idx(3)); %misclassified as cat B
        % look for pattern indices in the classification table

        ntrial=ntrain;
        textsize=30;
        fixation_size=20;
        yoffset=100;
        yoffset2=200;
        xadjust=100;
        feedcorroffset=400;%300
        feedxnameoffset=100;%100
        feedynameoffset=50;%100
        
        %isi=input('isi (secs) ');
        %scale=input(' scale [10] ');
        %radius=input(' radius [5] ');
        isi=.5;
        scale=10;
        radius=5;
        %
        %  set up Screen and define screen-related constants
        %
        %[wind1 rect] = Screen('OpenWindow',0,[255 255 255],[50 50 1200 700]);
        [wind1 rect] = Screen('OpenWindow',0,[255 255 255]);
        
        centerx=(rect(3)-rect(1))/2;
        centery=(rect(4)-rect(2))/2;
        topscreen=rect(2)+200; % adjust the vertical position of prompt
        bottomscreen=rect(4)-20;
        %
        fixation='*';
        press_space='When Ready, Press Space to Begin ';
        endblock='End of Test Block ';
        training_end='End of Training Phase';
        thanks='Thank You, the Experiment is Over!';
        pressq='(Press ''q'' to exit)';
        prompt='Category A, B, or C?';
        prompt2='Category A, B, or C?';
        text_correct='CORRECT!';
        text_incorrect='INCORRECT';
        text_okay='OKAY';
        percentage='Percent Correct= ';
%         block_end='End of Training Block ';
%         block_end_space='End of Training Block   ';
%         press_space_block='Press Space to Begin Training Block  ';
        
        catname{1}='A';
        catname{2}='B';
        catname{3}='C';
        
        Screen('TextSize',wind1,textsize);
        textbounds_thanks=Screen('TextBounds',wind1,thanks);
        textbounds_pressq=Screen('TextBounds',wind1,pressq);
        textbounds_press_space=Screen('TextBounds',wind1,press_space);
        textbounds_endblock=Screen('TextBounds',wind1,endblock);
        textbounds_training_end=Screen('TextBounds',wind1,training_end);
        textbounds_prompt=Screen('TextBounds',wind1,prompt);
        textbounds_prompt2=Screen('TextBounds',wind1,prompt2);
        textbounds_correct=Screen('TextBounds',wind1,text_correct);
        textbounds_incorrect=Screen('TextBounds',wind1,text_incorrect);
        textbounds_okay=Screen('TextBounds',wind1,text_okay);
        textbounds_percentage=Screen('TextBounds',wind1,percentage);
%         textbounds_block_end=Screen('TextBounds',wind1,block_end_space);
%         textbounds_press_space_block=Screen('TextBounds',wind1,press_space_block);
        
        phase_store=[];
        block_store=[];
        trial_store=[];
        itemtype_store=[];
        token_store=[];
        resp_store=[];
        correct_store=[];
        cat_store=[];
        rt_store=[];
        
        legalkeys={'r','t','y'};
        
        %%
        s_expt=RandStream('mt19937ar','Seed','Shuffle'); % randomize the order of pattern presentation
        RandStream.setGlobalStream(s_expt);
        WaitSecs(1)
        %%
        %  start of training phase of experiment
        %
        %   present instructions
        %
        instructions_train(wind1,rect);
        %
        Screen('TextSize',wind1,textsize)
        Screen('DrawText',wind1,press_space,rect(3)/2-textbounds_press_space(3)/2,rect(4)/2-textbounds_press_space(4)/2)
        Screen('Flip',wind1);
        WaitSecs(.5);
        legal=0;
        while legal == 0
            [keydown secs keycode]=KbCheck;
            key=KbName(keycode);
            if strcmp(key,'space')
                legal=1;
            end
        end
        Screen('Flip',wind1);
        WaitSecs(1);
        %
        tot_trials=0;
        itemtype=1;
        phase=1;
        %
        %  nblock blocks of ntrial training trials
        %
        for block=1:nblocktrian
%             Screen('DrawText',wind1,[press_space_block num2str(block)],rect(3)/2-textbounds_press_space_block(3)/2,rect(4)/2-textbounds_press_space_block(4)/2);
%             Screen('Flip',wind1)
%             legal=0;
%             while legal == 0
%                 [keydown secs keycode]=KbCheck;
%                 key=KbName(keycode);
%                 if ischar(key)
%                     if strcmp(key,'space')
%                         legal=1;
%                     end
%                 end
%             end
%             Screen('Flip',wind1);
%             WaitSecs(1);
            order=randperm(ntrain);
            for trial=1:ntrial
                tot_trials=tot_trials+1;
                istim=order(trial);
                icat=fix((istim-1)/n_old)+1;
                token=istim-n_old*(icat-1);
                distort = distort_old(icat,token);
                if cond == 4
                    idx_token = floor((token - 1)/3)+1;
                    index = train_idx(icat,distort,idx_token);
                else
                    index = train_idx(icat,token);
                end                
                for k=1:9
                    image(k,1)=train(icat,token,k,1);
                    image(k,2)=train(icat,token,k,2);
                end
                %
                %  present dot pattern and collect response
                dot_coords = repmat([centerx;centery],1,9)+scale*image';
                Screen('DrawDots',wind1,dot_coords,10,[0 0 0],[],2);
                Screen('DrawText',wind1,prompt,rect(3)/2-textbounds_prompt(3)/2,topscreen);
                Screen('Flip',wind1);
                legal=0;
                start=GetSecs;
                while legal == 0
                    [keydown secs keycode] = KbCheck;
                    key=KbName(keycode);
                    if ischar(key)
                        if any(strcmp(key,legalkeys))
                            legal=1;
                            rt=secs-start;
                        elseif strcmp(key,'q')
                            error('Debug quit!')
                        end
                    end
                end
                %
                % determine the subject's response
                %
                resp=0;
                switch key
                    case 'r'
                        resp=1;
                    case 't'
                        resp=2;
                    case 'y'
                        resp=3;
                end
                corr=0;
                if resp == icat
                    corr=1;
                end
                KbReleaseWait();
                Screen('Flip',wind1);
                
                %   present feedback while pattern remains on screen
                %
                actualname=catname{icat};
                dot_coords = repmat([centerx;centery],1,9)+scale*image';
                Screen('DrawDots',wind1,dot_coords, 10,[0 0 0],[],2);
                if corr == 1
                    Screen('DrawText',wind1,text_correct,rect(3)/2-textbounds_correct(3)/2,centery+feedcorroffset);
                else
                    Screen('DrawText',wind1,text_incorrect,rect(3)/2-textbounds_incorrect(3)/2,centery+feedcorroffset);
                end
                Screen('DrawText',wind1,actualname,centerx,centery+feedcorroffset+feedynameoffset)
                Screen('Flip',wind1);
                if corr == 1
                    WaitSecs(1);
                elseif corr == 0
                    WaitSecs(1);
                end
                Screen('Flip',wind1);
                %%
                %record results
                tot_trials=tot_trials+1;
                phase_store(tot_trials)=phase;
                block_store(tot_trials)=block;
                trial_store(tot_trials)=trial;
                itemtype_store(tot_trials)=itemtype;
                resp_store(tot_trials)=resp;
                cat_store(tot_trials)=icat;
                rt_store(tot_trials)=rt;
                corr_store(tot_trials)=corr;
                token_store(tot_trials)=token;
                distort_store(tot_trials)=distort;
                index_store(tot_trials)=index;
                for k=1:9
                    coord_store(tot_trials,k,1)=image(k,1);
                    coord_store(tot_trials,k,2)=image(k,2);
                end
                %%
                % write to output text file
                %
                fprintf(fid,'%5d',phase_store(tot_trials),block_store(tot_trials),trial_store(tot_trials),itemtype_store(tot_trials),...
                    cat_store(tot_trials),token_store(tot_trials),distort_store(tot_trials),index_store(tot_trials),...
                    resp_store(tot_trials),corr_store(tot_trials));
                fprintf(fid,'%10d',round(1000*rt_store(tot_trials)));
                for k=1:9
                    for m=1:2
                        fprintf(fid,'%5d',coord_store(tot_trials,k,m));
                    end
                end
                fprintf(fid,'\n');
                WaitSecs(isi)
            end   % trial
%             block_end_number = [block_end num2str(block)];
%             Screen('DrawText',wind1,block_end_number,rect(3)/2-textbounds_block_end(3)/2,centery);
%             Screen('Flip',wind1);    
%             WaitSecs(2);
%             Screen('Flip',wind1);
        end   %  block
        %
        Screen('DrawText',wind1,training_end,rect(3)/2-textbounds_training_end(3)/2,rect(4)/2-textbounds_training_end(4)/2)
        Screen('Flip',wind1);
        WaitSecs(2);
        %
        %  start test phase
        %
        %   present instructions
        %
        instructions_test(wind1,rect);
        %
        Screen('TextSize',wind1,textsize)
        Screen('DrawText',wind1,press_space,rect(3)/2-textbounds_press_space(3)/2,rect(4)/2-textbounds_press_space(4)/2)
        Screen('Flip',wind1);
        WaitSecs(.5);
        legal=0;
        while legal == 0
            [keydown secs keycode]=KbCheck;
            key=KbName(keycode);
            if strcmp(key,'space')
                legal=1;
            end
        end
        Screen('Flip',wind1);
        WaitSecs(1);
        
        %
        %   nblocktest blocks of ntrans test trials
        %
        phase=2;
        for block=1:nblocktest
            percent_correct=0;
            tot_test=0;
            order=randperm(ntrans);
            for trial=1:ntrans
                tot_trials=tot_trials+1;
                tot_test=tot_test+1;
                istim=order(trial);
                %
                % compute itemtype and construct the dot-pattern image
                %
                if istim <= (n_old*ncat)
                    itemtype=1;
                    icat=fix((istim-1)/n_old)+1;
                    token=istim-n_old*(icat-1);
                    distort = distort_old(icat,token);
                    if cond == 4
                        idx_token = floor((token - 1)/3)+1;
                        index = train_idx(icat,distort,idx_token);
                    else
                        index = train_idx(icat,token);
                    end
                    for k=1:9
                        for m=1:2
                            image(k,m)=train(icat,token,k,m);
                        end
                    end
                elseif istim >= (n_old*ncat)+1 && istim <= ((n_old+n_newlow)*ncat)
                    itemtype=3;
                    jstim=istim - (n_old*ncat);
                    icat=fix((jstim-1)/n_newlow)+1;
                    token=jstim-n_newlow*(icat-1);
                    distort = 1;
                    index = testlow_idx(icat,token);
                    for k=1:9
                        for m=1:2
                            image(k,m)=testlow(icat,token,k,m);
                        end
                    end
                elseif istim >= ((n_old+n_newlow)*ncat)+1 && istim <= ((n_old+n_newlow+n_newmed)*ncat)
                    itemtype=4;
                    jstim=istim - ((n_old+n_newlow)*ncat);
                    icat=fix((jstim-1)/n_newmed)+1;
                    token=jstim-n_newmed*(icat-1);
                    index = testmed_idx(icat,token);
                    distort = 2;
                    for k=1:9
                        for m=1:2
                            image(k,m)=testmed(icat,token,k,m);
                        end
                    end
                elseif istim >= ((n_old+n_newlow+n_newmed)*ncat)+1 && istim <= ((n_old+n_newlow+n_newmed+n_newhigh)*ncat)
                    itemtype=5;
                    jstim=istim - ((n_old+n_newlow+n_newmed)*ncat);
                    icat=fix((jstim-1)/n_newhigh)+1;
                    token=jstim-n_newhigh*(icat-1);
                    index = testhigh_idx(icat,token);
                    distort = 3;
                    for k=1:9
                        for m=1:2
                            image(k,m)=testhigh(icat,token,k,m);
                        end
                    end
                elseif istim >= ((n_old+n_newlow+n_newmed+n_newhigh)*ncat)+1 && istim <= ((n_old+n_newlow+n_newmed+n_newhigh+n_proto)*ncat)
                    itemtype=2;
                    jstim=istim - ((n_old+n_newlow+n_newmed+n_newhigh)*ncat);
                    icat=fix((jstim-1)/n_proto)+1;
                    token=0;
                    index = 0;
                    distort=0;
                    for k=1:9
                        for m=1:2
                            image(k,m)=proto(icat,k,m);
                        end
                    end
                elseif istim >= ((n_old+n_newlow+n_newmed+n_newhigh+n_proto)*ncat)+1 && istim <= ((n_old+n_newlow+n_newmed+n_newhigh+n_proto+n_newhigh_hard)*ncat)
                    itemtype=6;
                    jstim=istim - ((n_old+n_newlow+n_newmed+n_newhigh+n_proto)*ncat);
                    icat=fix((jstim-1)/n_newhigh_hard)+1;
                    token=0;
                    index = testhigh_hard_idx(icat);
                    distort = 3;
                    for k=1:9
                        for m=1:2
                            image(k,m)=testhigh_hard(icat,k,m);
                        end
                    end
                end
                %
                % present image and prompt and collect classification response
                dot_coords = repmat([centerx;centery],1,9)+scale*image';
                Screen('DrawDots',wind1,dot_coords, 10,[0 0 0],[],2);
                Screen('DrawText',wind1,prompt2,rect(3)/2-textbounds_prompt2(3)/2,topscreen);
                Screen('Flip',wind1);
                legal=0;
                start=GetSecs;
                while legal == 0
                    [keydown secs keycode] = KbCheck;
                    key=KbName(keycode);
                    if ischar(key)
                        if any(strcmp(key,legalkeys))
                            rt=secs-start;
                            legal=1;
                        elseif strcmp(key,'q')
                            error('Debug quit!')
                        end
                    end
                end
                %%
                %
                % determine the subject's response and whether it is correct
                %
                resp=0;
                switch key
                    case 'r'
                        resp=1;
                    case 't'
                        resp=2;
                    case 'y'
                        resp=3;
                end
                corr=0;
                if resp == icat
                    corr=1;
                end
                KbReleaseWait();
                Screen('Flip',wind1);
                if corr == 1
                    percent_correct=percent_correct+1;
                end
                
                %
                %  let subject know the response was recorded
                %
                Screen('DrawText',wind1,text_okay,rect(3)/2-textbounds_okay(3)/2,centery+feedcorroffset);
                Screen('Flip',wind1);
                WaitSecs(1);
                Screen('Flip',wind1);
                %%
                % record results
                %
                tot_trials=tot_trials+1;
                phase_store(tot_trials)=phase;
                block_store(tot_trials)=block;
                trial_store(tot_trials)=trial;
                itemtype_store(tot_trials)=itemtype;
                resp_store(tot_trials)=resp;
                cat_store(tot_trials)=icat;
                rt_store(tot_trials)=rt;
                corr_store(tot_trials)=corr;
                token_store(tot_trials)=token;
                distort_store(tot_trials)=distort;
                index_store(tot_trials)=index;
                for k=1:9
                    coord_store(tot_trials,k,1)=image(k,1);
                    coord_store(tot_trials,k,2)=image(k,2);
                end
                %%
                % write to output text file
                %
                fprintf(fid,'%5d',phase_store(tot_trials),block_store(tot_trials),trial_store(tot_trials),itemtype_store(tot_trials),...
                    cat_store(tot_trials),token_store(tot_trials),distort_store(tot_trials),index_store(tot_trials),...
                    resp_store(tot_trials),corr_store(tot_trials));
                fprintf(fid,'%10d',round(1000*rt_store(tot_trials)));
                for k=1:9
                    for m=1:2
                        fprintf(fid,'%5d',coord_store(tot_trials,k,m));
                    end
                end
                fprintf(fid,'\n');
                WaitSecs(isi)
            end   % trial
            percent_correct=percent_correct/tot_test;
            pcvalue=round(100*percent_correct);
            Screen('DrawText',wind1,[endblock num2str(block)],rect(3)/2-textbounds_endblock(3)/2,rect(4)/2-textbounds_endblock(4)/2)
            pcvalue_report=[percentage num2str(pcvalue)];
            Screen('DrawText',wind1,pcvalue_report,rect(3)/2-textbounds_percentage(3)/2,rect(4)/2-textbounds_percentage(4)/2+200);
            Screen('Flip',wind1);
            WaitSecs(3);
            Screen('Flip',wind1);
            WaitSecs(1);
        end   %  block
        %
        fclose(fid);
        save(allvars);
        Screen('DrawText',wind1,thanks,rect(3)/2-textbounds_thanks(3)/2,rect(4)/2-textbounds_thanks(4)/2);
        %    Screen('DrawText',wind1,pressq,rect(3)/2-textbounds_pressq(3)/2,rect(4)/2-textbounds_pressq(4)/2+50);
        Screen('Flip',wind1);
        WaitSecs(5);
        clear screen
    else
        disp('Error: the file already exists!')
    end
    
catch
    fclose('all');
    sca;
    psychrethrow(psychlasterror);
end
